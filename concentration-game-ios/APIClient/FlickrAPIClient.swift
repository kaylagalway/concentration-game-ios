//
//  FlickrAPIClient.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import Alamofire

struct FlickrAPIClient {
  
  static func fetchRecentPhotoInfo(_ completion: @escaping ([[String: Any]]) -> Void) {
    let flickrUrlString = FlickrConstants.flickrRequestUrl + FlickrConstants.method + FlickrConstants.apiKey + FlickrConstants.flickrKey + FlickrConstants.tags + FlickrConstants.perPage + FlickrConstants.format
    guard let photosUrl = URL(string: flickrUrlString) else {
      return
    }
    Alamofire.request(photosUrl, encoding: URLEncoding.default).responseJSON { response in
      guard let responseDict = response.result.value as? [String: Any], let photosDict = responseDict["photos"] as? [String: Any], let photosArray = photosDict["photo"] as? [[String: Any]] else {
        return
      }
      completion(photosArray)
    }
  }
  
  static func fetchImage(withFarm farm: Int, server: String, photoID: String, secret: String, completion: @escaping (UIImage) -> Void) throws {
    let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_m.jpg"
    guard let url = URL(string: urlString) else {
      throw(KittenPhotoError.urlError)
    }
    
    Alamofire.request(url, encoding: URLEncoding.default).responseJSON { response in
      completion(UIImage())
    }
  }
}
