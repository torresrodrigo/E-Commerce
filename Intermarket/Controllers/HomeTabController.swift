//
//  HomeTabController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit
import FirebaseAuth

class HomeTabController: UITabBarController {

    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func touchLogOutButton(_ sender: Any) {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Some error happen: \(signOutError)")
        }
    }
}
