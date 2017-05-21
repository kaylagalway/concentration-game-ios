//
//  FlickrConstants.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

struct FlickrConstants {
  
  static let flickrKey = "5423dbab63f23a62ca4a986e7cbb35e2"
  static let flickrRequestUrl = "https://api.flickr.com/services/rest/"
  static let method = "?method=flickr.photos.getRecent"
  static let apiKey = "&api_key="
  static let tags = "&tags=kittens"
  static let perPage = "&per_page=8"
  static let format = "&format=json&nojsoncallback=1"
  
}
