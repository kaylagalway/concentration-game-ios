//
//  GameNavigationController.swift
//  concentration-game-ios
//
//  Created by Kayla Galway on 5/23/17.
//  Copyright © 2017 Kayla Galway. All rights reserved.
//

import Foundation
import UIKit

class GameNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    customizeNavigationBar()
  }
  
  private func customizeNavigationBar() {
    adjustBackgroundColor()
    //adjustFont()
    adjustTintAndRemoveBackText()
  }
  
  private func adjustBackgroundColor() {
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
  
  /*
  private func adjustFont() {
    if let titleFont = UIFont(name: FontConstants.oratorStandard, size: 22) {
      navigationBar.titleTextAttributes = ([NSFontAttributeName: titleFont, NSForegroundColorAttributeName: UIColor.white])
    }
  }
 */
  
  private func adjustTintAndRemoveBackText() {
    navigationBar.tintColor = UIColor.white
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -500, vertical: -500), for: .default)
  }
  
}
