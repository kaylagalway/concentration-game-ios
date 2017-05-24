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
    contentView.addSubview(kittenImageViewBack)
    configure(imageView: kittenImageViewBack)
    configure(imageView: kittenImageViewFront)
    addConstraints(toImageView: kittenImageViewBack)
    kittenImageViewBack.backgroundColor = UIColor.black
  }
  
  func configure(imageView: UIImageView) {
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 1.0
  }
  
  func addConstraints(toImageView imageView: UIImageView) {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
  
  func resetImage() {
    isFlipped = true
    flipCard()
  }
  
  func flipCard() {
    defer {
      isFlipped = !isFlipped
    }
    let fromView: UIImageView! = isFlipped ? kittenImageViewFront : kittenImageViewBack
    let toView: UIImageView! = isFlipped ? kittenImageViewBack : kittenImageViewFront
    toView.isHidden = true
    contentView.addSubview(toView)
    addConstraints(toImageView: toView)
    UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    if isFlipped {
      UIView.setAnimationDelay(1.0)
    }
  }
}
