//
//  UIView+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
