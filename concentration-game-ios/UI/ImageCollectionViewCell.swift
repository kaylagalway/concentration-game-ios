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
  
  var isFlipped = false
  var kittenImageViewFront: UIImageView!
  var kittenImageViewBack: UIImageView!
  
  override init(frame: CGRect) {
    self.kittenImageViewFront = UIImageView()
    self.kittenImageViewBack = UIImageView(image: #imageLiteral(resourceName: "kittenFace"))
    super.init(frame: frame)
    addViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func addViews() {
    addFramesAndBordersToImageView(imageView: self.kittenImageViewBack)
    addFramesAndBordersToImageView(imageView: self.kittenImageViewFront)
    kittenImageViewBack.backgroundColor = UIColor.black
    contentView.addSubview(kittenImageViewBack)
  }
  
  func addFramesAndBordersToImageView(imageView: UIImageView) {
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.frame = contentView.frame
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 1.0
  }
  
  func flipToKittenImage() {
    if !isFlipped {
      UIView.transition(from: self.kittenImageViewBack, to: self.kittenImageViewFront, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
      isFlipped = true
    }
  }
  
  func returnCardToUnflipped() {
    if isFlipped {
      UIView.transition(from: self.kittenImageViewFront, to: self.kittenImageViewBack, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
      UIView.setAnimationDelay(1.0)
      isFlipped = false
    }
  }
  
}
