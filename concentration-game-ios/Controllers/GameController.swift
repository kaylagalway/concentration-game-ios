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
  
  func addMatchingPair(kittenPhoto: KittenPhotoModel, firstIndex: Int, secondIndex: Int) {
    let matchingPair = MatchingPair(firstIndex, secondIndex)
    matchingPairs[kittenPhoto] = matchingPair
  }
  
  var isMatchingPair: Bool {
    guard currentCards[0].row == currentCards[1].row else {
      return false
    }
    return true
  }
  
  func resetCurrentCards() {
    currentCards = [IndexPath]()
  }
  
}
