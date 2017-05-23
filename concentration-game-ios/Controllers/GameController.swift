//
//  GameController.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

class GameController: NSObject {
  
  typealias MatchingPair = (Int, Int)
  var matchingPairs: [KittenPhotoModel : MatchingPair] = [:]
  var photoIndexDict = [Int: KittenPhotoModel]()
  var currentCards = [IndexPath]()
  var players = [PlayerModel]()
  var flippedCards = 0
  
  func addMatchingPair(kittenPhoto: KittenPhotoModel, firstIndex: Int, secondIndex: Int) {
    let matchingPair = MatchingPair(firstIndex, secondIndex)
    matchingPairs[kittenPhoto] = matchingPair
  }
  
  var isMatchingPair: Bool {
    let firstCard = currentCards[0].row
    let secontCard = currentCards[1].row
    guard photoIndexDict[firstCard] == photoIndexDict[secontCard] else {
      return false
    }
    return true
  }
  
  func resetCurrentCardsArray() {
    currentCards = [IndexPath]()
  }
  
  func updatePlayerScore() {
    flippedCards += 2
  }
  
}
