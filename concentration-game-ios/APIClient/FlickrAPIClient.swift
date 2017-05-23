//
//  FlickrAPIClient.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import Alamofire

struct FlickrAPIConstants {
  
  static let flickrKey = "5423dbab63f23a62ca4a986e7cbb35e2"
  static let flickrRequestUrl = "https://api.flickr.com/services/rest/"
  static let searchMethod = "method=flickr.photos.search"
  static let apiKey = "&api_key="
  static let tags = "&tags=kittens"
  static let tagMode = "&tagmode=any"
  static let perPage = "&per_page=36"
  static let format = "&format=json&nojsoncallback=1"
  static let photos = "photos"
  static let photo = "photo"
  static let farmUrl = "https://farm"
  static let flickrUrl = ".staticflickr.com/"
  static let jpeg = "_n.jpg"
  
}

struct FlickrAPIClient {
  
  fileprivate typealias Constants = FlickrAPIConstants
  
  static func fetchRecentPhotoInfo(_ completion: @escaping ([[String: Any]]) -> Void) {
   //let flickrUrlString = Constants.flickrRequestUrl + Constants.searchMethod + Constants.apiKey + Constants.flickrKey + Constants.tags + Constants.tagMode + Constants.perPage + Constants.format
    let flickrUrlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5423dbab63f23a62ca4a986e7cbb35e2&tags=kittens&tagmode=any&per_page=40&format=json&nojsoncallback=1"
    guard let photosUrl = URL(string: flickrUrlString) else {
      return
    }
    Alamofire.request(photosUrl, encoding: URLEncoding.default).responseJSON { response in
      guard let responseDict = response.result.value as? [String: Any], let photosDict = responseDict[Constants.photos] as? [String: Any], let photosArray = photosDict[Constants.photo] as? [[String: Any]] else {
        return
      }
      completion(photosArray)
    }
  }
  
  static func fetchImage(withFarm farm: Int, server: String, photoID: String, secret: String, completion: @escaping (UIImage) -> Void) throws {
    let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg"
    guard let url = URL(string: urlString) else {
      throw(KittenPhotoError.urlError)
    }
    let datathing = NSData(contentsOf: url) as? Data
    let image = UIImage(data: datathing as! Data)
    completion(image!)
//    Alamofire.request(url, encoding: URLEncoding.default).responseString { response in
//      completion(UIImage())
//    }
  }
}
