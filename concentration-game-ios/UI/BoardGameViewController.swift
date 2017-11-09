//
//  BoardGameViewController.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/19/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

class BoardGameViewController: UIViewController {
  
  @IBOutlet weak var boardCollectionView: UICollectionView!
  @IBOutlet weak var difficultyButton: UIButton!
  @IBOutlet weak var playersButton: UIButton!
  @IBOutlet weak var matchLabel: UILabel!
  @IBOutlet weak var newGameButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var playerOneLabel: UILabel!
  @IBOutlet weak var playerTwoLabel: UILabel!
  fileprivate static let cellReuseID = "imageCell"
  fileprivate static let winView = "WinView"
  fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
  fileprivate var winView = WinView()
  var viewModel: BoardGameViewModel!
  
  override func viewDidLoad() {
    setUpCollectionView()
    viewModel = BoardGameViewModel(observer: self)
    viewModel.fetchAllImageInformation()
    playerTwoLabel.alpha = 0
    roundButtonEdges(button: difficultyButton)
    roundButtonEdges(button: playersButton)
    roundButtonEdges(button: newGameButton)
  }
  
  func reloadData() {
    boardCollectionView.isUserInteractionEnabled = true
    boardCollectionView.reloadData()
    boardCollectionView.collectionViewLayout.invalidateLayout()
    animateIndicatorRemoval()
  }
  
  private func animateIndicatorRemoval() {
    UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
      self.activityIndicator.alpha = 0
    }, completion: { (true) in
      self.activityIndicator.stopAnimating()
    })
  }
  
  private func setUpCollectionView() {
    boardCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: BoardGameViewController.cellReuseID)
    boardCollectionView.delegate = self
    boardCollectionView.dataSource = self
    boardCollectionView.layer.borderColor = UIColor.white.cgColor
    boardCollectionView.layer.borderWidth = 1.0
  }
  
  private func roundButtonEdges(button: UIButton) {
    button.layer.masksToBounds = true
    button.layer.cornerRadius = difficultyButton.frame.height * 0.1
    button.layoutIfNeeded()
  }
  
  func resetScoreLabels() {
    updatePlayerOneLabel(score: 0)
    updatePlayerTwoLabel(score: 0)
  }
  
  func returnCardsToUnflipped(firstCardPath: IndexPath,secondCardPath: IndexPath) {
    let firstCell = boardCollectionView.cellForItem(at: firstCardPath) as! ImageCollectionViewCell
    let secondCell = boardCollectionView.cellForItem(at: secondCardPath) as! ImageCollectionViewCell
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
      firstCell.flipCard()
      secondCell.flipCard()
      self.boardCollectionView.isUserInteractionEnabled = true
    }
  }
  
  func updatePlayerOneLabel(score: Int) {
    playerOneLabel.text = "PLAYER ONE: \(score) MATCHES"
  }
  
  func updatePlayerTwoLabel(score: Int) {
    playerTwoLabel.text = "PLAYER TWO: \(score) MATCHES"
  }
  
  func showMatchAnimation(playerOne: Int, playerTwo: Int) {
    UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
      self.matchLabel.alpha = 1
      self.updatePlayerOneLabel(score: playerOne)
      self.updatePlayerTwoLabel(score: playerTwo)
      self.boardCollectionView.isUserInteractionEnabled = true
    }, completion: { (true) in
      UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseIn, animations: {
        self.matchLabel.alpha = 0
        self.boardCollectionView.isUserInteractionEnabled = true
      }, completion: nil)
    })
  }
  
  func showWin(winner: PlayerModel?) {
    guard let view = Bundle.main.loadNibNamed(BoardGameViewController.winView, owner: nil, options: nil)?.first as? WinView else {
      return
    }
    winView = view
    winView.frame = boardCollectionView.frame
    winView.alpha = 0
    winView.layer.borderColor = UIColor.white.cgColor
    winView.layer.borderWidth = 1.0
    winView.winnerLabel.text = generateWinText(winner: winner?.playerName)
    UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
      self.view.addSubview(self.winView)
      self.winView.alpha = 1
      self.view.bringSubview(toFront: self.winView)
    }, completion: nil)
  }
  
  private func generateWinText(winner: String?) -> String {
    guard let winnerName = winner else {
      return "YOU TIED!"
    }
    return "\(winnerName.uppercased()) WINS!"
  }
  
  @IBAction func playersButtonTapped(_ sender: Any) {
    let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let onePlayer = UIAlertAction(title: "1 Player", style: .default) { action in
      self.playerTwoLabel.alpha = 0
      self.presentLoadingIndicator()
      self.viewModel.updateNumberOfPlayers(players: 1)
      self.viewModel.fetchAllImageInformation()
    }
    let twoPlayer = UIAlertAction(title: "2 Player", style: .default) { action in
      self.playerTwoLabel.alpha = 1
      self.presentLoadingIndicator()
      self.viewModel.updateNumberOfPlayers(players: 2)
      self.viewModel.fetchAllImageInformation()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheetController.addAction(onePlayer)
    actionSheetController.addAction(twoPlayer)
    actionSheetController.addAction(cancelAction)
    present(actionSheetController, animated: true, completion: nil)
  }
  
  @IBAction func newGameButtonTapped(_ sender: Any) {
    activityIndicator.startAnimating()
    activityIndicator.alpha = 1
    viewModel.fetchAllImageInformation()
    winView.removeFromSuperview()
  }
  
  @IBAction func difficultyButtonTapped(_ sender: Any) {
    let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let easyOption = UIAlertAction(title: "Easy", style: .default) { action in
      self.presentLoadingIndicator()
      self.viewModel.difficulty = .easy
    }
    let mediumOption = UIAlertAction(title: "Medium", style: .default) { action in
      self.presentLoadingIndicator()
      self.viewModel.difficulty = .medium
    }
    let hardOption = UIAlertAction(title: "Hard", style: .default) { action in
      self.presentLoadingIndicator()
      self.viewModel.difficulty = .hard
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheetController.addAction(easyOption)
    actionSheetController.addAction(mediumOption)
    actionSheetController.addAction(hardOption)
    actionSheetController.addAction(cancelAction)
    present(actionSheetController, animated: true, completion: nil)
  }
  
  private func presentLoadingIndicator() {
    self.activityIndicator.startAnimating()
    self.activityIndicator.alpha = 1
  }
  
  func presentRetryError() {
    let alertController = UIAlertController(title: "Sorry, there was a problem!", message: "Do you want to try again?", preferredStyle: .alert)
    let retryOption = UIAlertAction(title: "Retry", style: .default) { action in
      self.viewModel.fetchAllImageInformation()
    }
    alertController.addAction(retryOption)
    present(alertController, animated: true, completion: nil)
  }
  
  func twoCardsFlipped() {
    boardCollectionView.isUserInteractionEnabled = false
  }
  
}

extension BoardGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Int(viewModel.numberOfSquares)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = boardCollectionView.dequeueReusableCell(withReuseIdentifier: BoardGameViewController.cellReuseID, for: indexPath) as! ImageCollectionViewCell
    if let kittenImage = viewModel.imageForCell(index: indexPath.row) {
      cell.kittenImageViewFront.image = kittenImage
      cell.resetImage()
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
    if !cell.isFlipped {
      cell.flipCard()
      viewModel.checkForMatch(indexPath: indexPath)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let padding = sectionInsets.left * CGFloat(viewModel.squaresPerRow + 1)
    let remainingWidth = boardCollectionView.frame.width - padding
    let widthPerItem = remainingWidth / CGFloat(viewModel.squaresPerRow)
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
  
}
