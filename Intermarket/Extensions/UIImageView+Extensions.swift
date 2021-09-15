//
//  UIImageView+Controller.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 15/09/2021.
//

import Foundation
import UIKit

extension UIImageView {
  public func maskCircle(anyImage: UIImage) {
    self.contentMode = .scaleAspectFill
    self.layer.cornerRadius = self.frame.width / 2
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.masksToBounds = false
    self.clipsToBounds = true
    self.image = anyImage
  }
}
