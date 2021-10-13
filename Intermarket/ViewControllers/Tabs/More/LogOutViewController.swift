//
//  LogOutViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 15/09/2021.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin


class LogOutViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backAction()
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutAction()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        backAction()
    }
    
    func backAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func logOutAction() {
        removeUserDefaults()
        checkTypeLogin()
    }
    
    func checkTypeLogin() {
        guard let typeLogin: LoginType = UserDefaultsManager.sharedInstance.getLoginType() else { return }
        switch typeLogin  {
        case .Google:
            GIDSignIn.sharedInstance.signOut()
        case .Apple:
            firebaseLogOut()
        case .Facebook:
            LoginManager().logOut()
        }
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
