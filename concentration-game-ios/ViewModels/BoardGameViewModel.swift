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

struct ViewModelConstants {
  static let id = "id"
  static let farm = "farm"
  static let secret = "secret"
  static let server = "server"
  static let title = "title"
}

class BoardGameViewModel: NSObject {
  
  fileprivate static let easyBoard = 16.0
  fileprivate static let mediumBoard = 25.0
  fileprivate static let hardBoard = 36.0
  fileprivate typealias Constants = ViewModelConstants
  var kittenPhotos = [KittenPhotoModel]()
  weak var observer: BoardGameViewController?
  var gameController = GameController()
  var squaresPerRow = 4
  
  var difficulty = DifficultyLevelEnum.easy {
    didSet {
      fetchAllImageInformation()
    }
  }
  
  var numberOfSquares: Double {
    switch difficulty {
    case .easy:
      squaresPerRow = 4
      return BoardGameViewModel.easyBoard
    case .medium:
      squaresPerRow = 5
      return BoardGameViewModel.mediumBoard
    case .hard:
      squaresPerRow = 6
      return BoardGameViewModel.hardBoard
    }
  }
  
  init(observer: BoardGameViewController) {
    self.observer = observer
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
    guard let photoID = photoDict[Constants.id] as? String, let farm = photoDict[Constants.farm] as? Int, let secret = photoDict[Constants.secret] as? String, let server = photoDict[Constants.server] as? String, let title = photoDict[Constants.title] as? String else {
      return
    }
    try? FlickrAPIClient.fetchImage(withFarm: farm, server: server, photoID: photoID, secret: secret) { image in
      let kittenPhoto = KittenPhotoModel(photoID: photoID, title: title, image: image)
      completion(kittenPhoto)
    }
  }
  
  //add images to random index on board
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
      gameController.resetCurrentCardsArray()
      return
    }
    gameController.resetCurrentCardsArray()
    observer?.showMatchAnimation()
    gameController.updatePlayerScore()
    checkForFinishedGame()
  }
  
  func checkForFinishedGame() {
    guard gameController.flippedCards != Int(numberOfSquares) else {
      observer?.showWin()
      return
    }
  }
  
}
