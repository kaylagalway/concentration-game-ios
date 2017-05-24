//
//  PlayerModel.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/23/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

class PlayerModel {
  
  let playerName: String
  var playerScore: Int
  
  init(playerName: String, playerScore: Int) {
    self.playerName = playerName
    self.playerScore = playerScore
  }
  
  var hashValue: Int {
    return playerName.hashValue
  }
  
  static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
    return lhs.playerName == rhs.playerName &&
      lhs.playerScore == rhs.playerScore
  }
  
}
