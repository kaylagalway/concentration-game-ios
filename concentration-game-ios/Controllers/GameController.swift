//
//  GameController.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/20/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation

class GameController: NSObject {
  
  var photoIndexDict = [Int: KittenPhotoModel]()
  var currentCards = [IndexPath]()
  var currentPlayer: PlayerModel
  fileprivate var playerOne = PlayerModel(playerName: "Player 1", playerScore: 0)
  fileprivate var playerTwo = PlayerModel(playerName: "Player 2", playerScore: 0)
  var flippedCards = 0
  var numberOfPlayers = 1
  
  override init() {
    currentPlayer = playerOne
  }
  
  var isMatchingPair: Bool {
    let firstCard = currentCards[0].row
    let secontCard = currentCards[1].row
    guard photoIndexDict[firstCard] == photoIndexDict[secontCard] else {
      return false
    }
    return true
  }
  
  var isPlayerOneTurn: Bool {
    return currentPlayer == playerOne
  }
  
  var playerOneScore: Int {
   return playerOne.playerScore
  }
  
  var playerTwoScore: Int {
    return playerTwo.playerScore
  }
  
  var winner: PlayerModel? {
    guard playerOneScore != playerTwoScore else {
      return nil
    }
    return playerOneScore > playerTwoScore ? playerOne : playerTwo
  }
  
  func resetGame() {
    currentPlayer = playerOne
    currentCards = [IndexPath]()
    playerOne.playerScore = 0
    playerTwo.playerScore = 0
    flippedCards = 0
  }
  
  var didSelectSecondCard: Bool {
    return currentCards.count == 2
  }
  
  func selectCard(indexPath: IndexPath) {
    currentCards.append(indexPath)
  }
  
  func checkForMatch(indexPath: IndexPath) -> Bool {
    guard isMatchingPair else {
      toggleCurrentPlayer()
      return false
    }
    increaseCardsCount()
    increasePlayerScore()
    toggleCurrentPlayer()
    return true
  }
  
  func resetCurrentCardsArray() {
    currentCards = [IndexPath]()
  }
  
  private func increaseCardsCount() {
    flippedCards += 2
  }
  
  private func increasePlayerScore() {
    currentPlayer.playerScore += 1
  }
  
  private func toggleCurrentPlayer() {
    if numberOfPlayers == 2 {
     currentPlayer = isPlayerOneTurn ? playerTwo : playerOne 
    }
  }
  
}
