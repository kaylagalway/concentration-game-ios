//
//  KittenPhotoModel.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

struct KittenPhotoModel {
  
  let photoId: String
  let farm: Int
  let secret: String
  let server: String
  let title: String
  
  var photoUrl: NSURL {
    return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
  }
  
}
