//
//  KittenPhotoModel.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

enum KittenPhotoError: Error {
  case urlError
  case unknownError
}

struct KittenPhoto: Hashable {
  //consider removing
  let photoId: String
  let farm: Int
  let secret: String
  let server: String
  let title: String
  var image = UIImage()
  
  var hashValue: Int {
    return photoId.hashValue
  }
  
  static func == (lhs: KittenPhoto, rhs: KittenPhoto) -> Bool {
    return lhs.photoId == rhs.photoId &&
      lhs.farm == rhs.farm &&
      lhs.secret == rhs.secret &&
      lhs.server == rhs.server &&
      lhs.title == rhs.title
  }
}
