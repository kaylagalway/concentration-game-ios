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
  
  static func fetchRecentPhotos(_ completion: @escaping ([[String: Any]]) -> Void) {
    let flickrUrlString = FlickrConstants.flickrRequestUrl + FlickrConstants.method + FlickrConstants.apiKey + FlickrConstants.flickrKey + FlickrConstants.tags + FlickrConstants.perPage + FlickrConstants.format
    guard let photosUrl = URL(string: flickrUrlString) else {
      return
    }
    Alamofire.request(photosUrl, encoding: URLEncoding.default).responseJSON { (response) in
      guard let responseDict = response.result.value as? [String: Any], let photosDict = responseDict["photos"] as? [String: Any], let photosArray = photosDict["photo"] as? [[String: Any]] else {
        return
      }
      completion(photosArray)
    }
  }
  
  static func fetchImage(dictionary: [String: Any]) {
    
    
  }
  
}
