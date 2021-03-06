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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareAction(segue: segue)
    }
    
    func prepareAction(segue: UIStoryboardSegue) {
        if segue.identifier == Identifier.GoToProfile {
            goToProfileVC(segue: segue)
        }
        else if segue.identifier == Identifier.GoToLogOut {
            goToLogOutVC(segue: segue)
        }
    }
    
    func goToProfileVC(segue: UIStoryboardSegue) {
        let vc = segue.destination as? ProfileViewController
        vc?.modalPresentationStyle = .fullScreen
    }
    
    func goToLogOutVC(segue: UIStoryboardSegue) {
        let vc = segue.destination as? LogOutViewController
        vc?.modalPresentationStyle = .fullScreen
    }
    
}

