//
//  UIViewController+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentViewController(with viewController: UIViewController, barHidden hidden: Bool){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = hidden
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
