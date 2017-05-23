//
//  PlayerModel.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/23/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

struct PlayerModel: Hashable {
  
  let playerName: String
  var playerScore: Int
  
  var hashValue: Int {
    return playerName.hashValue
  }
  
  static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
    return lhs.playerName == rhs.playerName &&
      lhs.playerScore == rhs.playerScore
  }
  
}
