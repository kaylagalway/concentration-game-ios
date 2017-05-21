//
//  BoardGameViewModel.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

enum DifficultyLevelEnum {
  case easy
  case medium
  case hard
}

protocol BoardGameViewModelDelegate {
  func allPhotosDidLoad()
}

class BoardGameViewModel: NSObject {
  
  fileprivate static let easyBoard = 16
  fileprivate static let mediumBoard = 25
  fileprivate static let hardBoard = 36
  var kittenPhotos = [KittenPhoto]()
  var difficulty = DifficultyLevelEnum.easy {
    didSet {
      fetchAllImageInformation()
    }
  }
  weak var observer: BoardGameViewController?
  
  init(observer: BoardGameViewController) {
    self.observer = observer
  }
  
  var numberOfSquares: Int {
    switch difficulty {
    case .easy:
      return BoardGameViewModel.easyBoard
    case .medium:
      return BoardGameViewModel.mediumBoard
    case .hard:
      return BoardGameViewModel.hardBoard
    }
  }
  
  func fetchAllImageInformation() {
    FlickrAPIClient.fetchRecentPhotoInfo { [weak self] photos in
      let dispatchGroup = DispatchGroup()
      for photoInfo in photos {
        dispatchGroup.enter()
        self?.loadImage(photoDict: photoInfo) { [weak self] kittenPhoto in
          self?.kittenPhotos.append(kittenPhoto)
          debugPrint("\(String(describing: self?.kittenPhotos.count))")
          dispatchGroup.leave()
        }
      }
      dispatchGroup.notify(queue: .main) {
        self?.observer?.reloadData()
      }
    }
  }
  
  func loadImage(photoDict: [String: Any], completion: @escaping (KittenPhoto) -> Void) {
    guard let photoID = photoDict["id"] as? String, let farm = photoDict["farm"] as? Int, let secret = photoDict["secret"] as? String, let server = photoDict["server"] as? String, let title = photoDict["title"] as? String else {
      return
    }
    try? FlickrAPIClient.fetchImage(withFarm: farm, server: server, photoID: photoID, secret: secret) { image in
      let kittenPhoto = KittenPhoto(photoId: photoID, farm: farm, secret: secret, server: server, title: title, image: image)
      completion(kittenPhoto)
    }
  }
  
}
