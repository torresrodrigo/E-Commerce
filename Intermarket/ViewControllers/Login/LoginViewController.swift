//
//  LoginViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var signInAppleButton: UIButton!
    @IBOutlet weak var signInFacebook: UIButton!
    
    let userDefaults = UserDefaults.standard
    var currentNounce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        onBoardingCheck()
    }

    @IBAction func touchButtonSignIn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            LoginService.shared.loginGoogle(viewController: self)
        case 1:
            LoginService.shared.loginFacebook(viewController: self)
        case 2:
            setupAppleSignIn()
        default:
            print("Not exits")
        }
    }
    
    private func setupUI() {
        setupButtons()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupButtons() {
        setupColorsBorder()
        setupImagesButtons()
    }
    
    private func setupColorsBorder() {
        signInAppleButton.layer.borderColor = Colors.ButtonRadiusColor
        signInGoogleButton.layer.borderColor = Colors.ButtonRadiusColor
        signInFacebook.layer.borderColor = Colors.ButtonRadiusColor
    }
    
    private func setupImagesButtons() {
        signInGoogleButton.setImage(Icons.Google, for: .normal)
        signInAppleButton.setImage(Icons.Apple, for: .normal)
        signInFacebook.setImage(Icons.Facebook, for: .normal)
        setupEdgeImage()
    }

    private func setupEdgeImage() {
        signInGoogleButton.imageEdgeInsets.left = -65
        signInAppleButton.imageEdgeInsets.left = -72
        signInFacebook.imageEdgeInsets.left = -50
    }
    
    func onBoardingCheck() {
        userDefaults.set(true, forKey: UserDefaultsKeys.OnboardingCheck)
    }
    
}


