//
//  SearchViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class SearchViewController: UIViewController {
    
    static let identifier = String(describing: SearchViewController.self)
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOut(_ sender: Any) {
        print("Worked")
    }
    @IBAction func actionLogOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
        firebaseLogOut()
    }
    
    @IBAction func touchOtherVcButton(_ sender: Any) {
        //presentViewController(with: UIViewController(nibName: CartViewController().identifier, bundle: nil), barHidden: false)
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
