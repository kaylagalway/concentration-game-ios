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
  fileprivate static let cellReuseID = "imageCell"
  fileprivate static let itemPadding: CGFloat = 10.0
  let layout = UICollectionViewFlowLayout()
  var viewModel: BoardGameViewModel!
  
  override func viewDidLoad() {
    boardCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: BoardGameViewController.cellReuseID)
    viewModel = BoardGameViewModel(observer: self)
    setUpCollectionViewFlowLayout()
    viewModel.fetchAllImageInformation()
    roundButtonEdges()
  }
  
  func reloadData() {
    setUpCollectionViewFlowLayout()
    boardCollectionView.reloadData()
  }
  
  private func setUpCollectionViewFlowLayout() {
    boardCollectionView.delegate = self
    boardCollectionView.dataSource = self
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
  
  func roundButtonEdges() {
    difficultyButton.layer.masksToBounds = true
    difficultyButton.layer.cornerRadius = difficultyButton.frame.height * 0.1
    difficultyButton.layoutIfNeeded()
  }
  
  @IBAction func difficultyButtonTapped(_ sender: Any) {
    viewModel.difficulty = .medium
  }
  
  func returnCardsToUnflipped(firstCardPath: IndexPath,secondCardPath: IndexPath) {
    let firstCell = boardCollectionView.cellForItem(at: firstCardPath) as! ImageCollectionViewCell
    let secondCell = boardCollectionView.cellForItem(at: secondCardPath) as! ImageCollectionViewCell
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
      firstCell.returnCardToUnflipped()
      secondCell.returnCardToUnflipped()
    }
  }
  
  func showMatchAnimation() {
    
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
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
    cell.flipToKittenImage()
    viewModel.checkForMatch(indexPath: indexPath)
  }
  
  
}
