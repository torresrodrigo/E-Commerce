//
//  MainTabViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import UIKit

class MainTabViewController: UITabBarController {

    let titleNav = "Inter Market"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomNavBar()
    }
    
    func setupBottomNavBar() {
        tabBar.barStyle = .black
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        tabBar.tintColor = Colors.BarTint
    }
    
}



