//
//  UIViewController+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentViewController(with viewController: UIViewController, barHidden hidden: Bool) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.setupNavBar()
        navigationController.isNavigationBarHidden = hidden
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func embbededNavigationController(forHidden hidden: Bool) -> BaseNavigationController {
        let nav = BaseNavigationController(rootViewController: self)
        nav.navigationBar.setupNavBar()
        nav.isNavigationBarHidden = hidden
        return nav
    }
    
}

extension UINavigationBar {
    fileprivate func setupNavBar(){
        self.barStyle = .black
        self.isTranslucent = false
        self.barTintColor = Colors.Primary
        self.tintColor = .white
        
    }
}
