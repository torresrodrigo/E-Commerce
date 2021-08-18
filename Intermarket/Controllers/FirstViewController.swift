//
//  FirstViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class FirstViewController: UIViewController {

    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func touchLogOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
        firebaseLogOut()
    }
    
    func firebaseLogOut() {
        do {
            try firebaseAuth.signOut()
            presentViewController(with: LoginViewController(), barHidden: true)
        } catch let signOutError as NSError {
            print("Some error happen: \(signOutError)")
        }
    }
}
