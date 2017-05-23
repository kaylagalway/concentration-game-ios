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
  
  fileprivate static let easyBoard = 16.0
  fileprivate static let mediumBoard = 25.0
  fileprivate static let hardBoard = 36.0
  var kittenPhotos = [KittenPhotoModel]()
  weak var observer: BoardGameViewController?
  var gameController = GameController()
  
  var difficulty = DifficultyLevelEnum.easy {
    didSet {
      fetchAllImageInformation()
    }
  }
  
  init(observer: BoardGameViewController) {
    self.observer = observer
  }
  
  var numberOfSquares: Double {
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
          dispatchGroup.leave()
        }
      }
      dispatchGroup.notify(queue: .main) {
        self?.fillBoardWithImages()
        self?.observer?.reloadData()
      }
    }
  }
  
  func loadImage(photoDict: [String: Any], completion: @escaping (KittenPhotoModel) -> Void) {
    guard let photoID = photoDict["id"] as? String, let farm = photoDict["farm"] as? Int, let secret = photoDict["secret"] as? String, let server = photoDict["server"] as? String, let title = photoDict["title"] as? String else {
      return
    }
    try? FlickrAPIClient.fetchImage(withFarm: farm, server: server, photoID: photoID, secret: secret) { image in
      let kittenPhoto = KittenPhotoModel(photoID: photoID, title: title, image: image)
      completion(kittenPhoto)
    }
  }
  
  func fillBoardWithImages() {
    var indexArray = Array(0...Int(numberOfSquares) - 1)
    for index in 0...((indexArray.count / 2) - 1) {
      let kittenPhoto = kittenPhotos[index]
      let firstRandomIndex = Int(arc4random_uniform(UInt32(indexArray.count)))
      let firstItem = indexArray[firstRandomIndex]
      gameController.photoIndexDict[firstItem] = kittenPhoto
      indexArray.remove(at: firstRandomIndex)
      let secondRandomIndex = Int(arc4random_uniform(UInt32(indexArray.count)))
      let secondItem = indexArray[secondRandomIndex]
      gameController.photoIndexDict[secondItem] = kittenPhoto
      indexArray.remove(at: secondRandomIndex)
    }
  }
  
  func imageForCell(index: Int) -> UIImage? {
    guard let kittenPhoto = gameController.photoIndexDict[index] else {
      return nil
    }
    return kittenPhoto.image
  }
  
  func checkForMatch(indexPath: IndexPath) {
    gameController.currentCards.append(indexPath)
    guard gameController.currentCards.count == 2 else {
      return
    }
    guard gameController.isMatchingPair else {
      observer?.returnCardsToUnflipped(firstCardPath: gameController.currentCards[0], secondCardPath: gameController.currentCards[1])
      gameController.resetCurrentCards()
      return
    }
    
    
  }
  
}
