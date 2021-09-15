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
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    let userDefaults = UserDefaults.standard
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @IBAction func actionLogOut(_ sender: Any) {
        removeUserDefaults()
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
        firebaseLogOut()
    }
    
    func setupUI() {
        setupButtons()
    }
    
    func setupButtons() {
        profileButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        profileButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
        logOutButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        logOutButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
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
