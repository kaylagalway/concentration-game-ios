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
  let layout = UICollectionViewFlowLayout()
  var viewModel: BoardGameViewModel!
  
  override func viewDidLoad() {
    setUpCollectionViewFlowLayout()
    boardCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
    //viewModel = BoardGameViewModel(observer: self)
    //viewModel.fetchAllImageInformation()
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
//      self.viewModel.difficulty = .medium
//    }

  }
  
  func reloadData() {
    //Remake the board
    
  }
  
  private func setUpCollectionViewFlowLayout() {
    boardCollectionView.delegate = self
    boardCollectionView.dataSource = self
    let halvedWidthOfCollection = floor(boardCollectionView.frame.width / 4)
    let itemPadding = CGFloat(10.0)
    let collectionItemSize = halvedWidthOfCollection - itemPadding
    layout.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
    let margin = (boardCollectionView.frame.width - (collectionItemSize * 4)) / 4
    layout.minimumInteritemSpacing = margin - 10
    layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    layout.minimumLineSpacing = margin
    boardCollectionView.setCollectionViewLayout(layout, animated: true)
  }
  
}

extension BoardGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 16
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = boardCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  
}
