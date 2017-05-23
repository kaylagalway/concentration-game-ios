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
  @IBOutlet weak var matchLabel: UILabel!
  @IBOutlet weak var newGameButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  fileprivate static let cellReuseID = "imageCell"
  fileprivate static let matchText = "MATCH!"
  fileprivate static let winView = "WinView"
  fileprivate static let itemPadding: CGFloat = 10.0
  let layout = UICollectionViewFlowLayout()
  var winView = UIView()
  var viewModel: BoardGameViewModel!
  
  override func viewDidLoad() {
    boardCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: BoardGameViewController.cellReuseID)
    boardCollectionView.delegate = self
    boardCollectionView.dataSource = self
    viewModel = BoardGameViewModel(observer: self)
    viewModel.fetchAllImageInformation()
    setUpCollectionViewFlowLayout()
    roundButtonEdges()
  }
  
  func reloadData() {
    layout.invalidateLayout()
    setUpCollectionViewFlowLayout()
    boardCollectionView.reloadData()
    animateIndicatorRemoval()
  }
  
  func animateIndicatorRemoval() {
    UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
      self.activityIndicator.alpha = 0
    }, completion: { (true) in
      self.activityIndicator.stopAnimating()
    })
  }
  
  private func setUpCollectionViewFlowLayout() {
    let squaresPerRow = CGFloat(viewModel.numberOfSquares.squareRoot())
    let halvedWidthOfCollection = floor(boardCollectionView.frame.width / squaresPerRow)
    let collectionItemSize = halvedWidthOfCollection - BoardGameViewController.itemPadding
    layout.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
    let margin = (boardCollectionView.frame.width - (collectionItemSize * squaresPerRow)) / 4
    layout.minimumInteritemSpacing = margin - BoardGameViewController.itemPadding
    layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    layout.minimumLineSpacing = margin
    boardCollectionView.setCollectionViewLayout(layout, animated: true)
    boardCollectionView.layer.borderColor = UIColor.white.cgColor
    boardCollectionView.layer.borderWidth = 1.0
  }
  
  private func roundButtonEdges() {
    difficultyButton.layer.masksToBounds = true
    difficultyButton.layer.cornerRadius = difficultyButton.frame.height * 0.1
    difficultyButton.layoutIfNeeded()
    newGameButton.layer.masksToBounds = true
    newGameButton.layer.cornerRadius = difficultyButton.frame.height * 0.1
    newGameButton.layoutIfNeeded()
  }
  
  func returnCardsToUnflipped(firstCardPath: IndexPath,secondCardPath: IndexPath) {
    let firstCell = boardCollectionView.cellForItem(at: firstCardPath) as! ImageCollectionViewCell
    let secondCell = boardCollectionView.cellForItem(at: secondCardPath) as! ImageCollectionViewCell
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
      firstCell.returnCardToUnflipped()
      secondCell.returnCardToUnflipped()
    }
  }
  
  func showMatchAnimation() {
    UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
      self.matchLabel.alpha = 1
    }, completion: { (true) in
      UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseIn, animations: {
        self.matchLabel.alpha = 0
      }, completion: nil)
    })
  }
  
  func showWin() {
    guard let view = Bundle.main.loadNibNamed(BoardGameViewController.winView, owner: nil, options: nil)?.first as? UIView else {
      return
    }
    winView = view
    winView.frame = boardCollectionView.frame
    winView.alpha = 0
    winView.layer.borderColor = UIColor.white.cgColor
    winView.layer.borderWidth = 1.0
    UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
      self.view.addSubview(self.winView)
      self.winView.alpha = 1
      self.view.bringSubview(toFront: self.winView)
    }, completion: nil)
  }
  
  @IBAction func difficultyButtonTapped(_ sender: Any) {
    activityIndicator.startAnimating()
    activityIndicator.alpha = 1
    viewModel.difficulty = .medium
  }
  
  @IBAction func newGameButtonTapped(_ sender: Any) {
    activityIndicator.startAnimating()
    activityIndicator.alpha = 1
    viewModel.fetchAllImageInformation()
    winView.removeFromSuperview()
  }
}

extension BoardGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
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
      cell.returnCardToUnflipped()
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
    cell.flipToKittenImage()
    viewModel.checkForMatch(indexPath: indexPath)
  }
  
  
}
