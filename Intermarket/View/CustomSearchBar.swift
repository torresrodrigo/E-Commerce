//
//  CustomSearchBar.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 20/08/2021.
//

import UIKit

class CustomSearchBar: UISearchBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        clearBackgroundColor() // function in the question
    }
    
    private func clearBackgroundColor() {
        for view in self.subviews {
            view.alpha = 0
            for subview in view.subviews {
                subview.backgroundColor = UIColor.clear
            }
        }
    }
}
