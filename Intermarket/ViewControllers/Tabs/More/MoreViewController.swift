//
//  MoreViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 20/08/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class MoreViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func actionLogOut(_ sender: Any) {
        removeUserDefaults()
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
        firebaseLogOut()
    }
    
    func firebaseLogOut() {
        do {
            try firebaseAuth.signOut()
            self.navigationController?.presentViewController(with: LoginViewController(), barHidden: true)
        } catch let signOutError as NSError {
            print("Some error happen: \(signOutError)")
        }
    }
    
    func removeUserDefaults() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.LoggedUser)
    }
}
