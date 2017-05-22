//
//  ImageCollectionViewCell.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/19/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  
  var isMatched = false
  var cardFront: UIImageView!
  var cardBack: UIImageView!
  
  override init(frame: CGRect) {
    self.cardFront = UIImageView(image: #imageLiteral(resourceName: "frontPlayingCard"))
    self.cardBack = UIImageView(image: #imageLiteral(resourceName: "backPlayingCard"))
    super.init(frame: frame)
    addViewsToCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func addViewsToCell() {
    cardFront.frame = contentView.frame
    cardBack.frame = contentView.frame
    contentView.addSubview(cardFront)
  }
  
  func flipCard() {
    
  }
  
  func returnToUnflipped() {
    
  }
  
}
