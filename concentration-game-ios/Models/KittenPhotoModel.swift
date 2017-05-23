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

struct KittenPhotoModel: Hashable {
  let photoID: String
  let title: String
  var image: UIImage
  
  var hashValue: Int {
    return photoID.hashValue
  }
  
  static func == (lhs: KittenPhotoModel, rhs: KittenPhotoModel) -> Bool {
    return lhs.photoID == rhs.photoID &&
      lhs.title == rhs.title &&
      lhs.image == rhs.image
  }
}
