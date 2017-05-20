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
  
  override func viewDidLoad() {
    setUpCollectionViewFlowLayout()
    FlickrAPIClient.fetchRecentPhotos { response in
      
    }
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardGameCell", for: indexPath) as! ImageCollectionViewCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  
}
