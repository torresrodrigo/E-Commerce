//
//  UIView+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var borderHeight: CGFloat {
        get { return self.borderHeight }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}
