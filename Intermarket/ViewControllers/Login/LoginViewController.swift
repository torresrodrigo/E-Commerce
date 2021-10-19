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
    
    @IBOutlet weak var intermarketLabel: UILabel!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var loginSubtitle: UILabel!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var signInAppleButton: UIButton!
    @IBOutlet weak var signInFacebook: UIButton!
    @IBOutlet weak var imgLogin: UIImageView!
    
    let userDefaults = UserDefaults.standard
    var currentNounce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        onBoardingCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAnimationUI()
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

// Animations
extension LoginViewController {
    func showAnimationUI() {
        animateUI()
    }
    
    func animateUI() {
        self.perform(#selector(animateLabels), with: nil, afterDelay: 0.5)
        self.perform(#selector(animateButtons), with: nil, afterDelay: 1)
        self.perform(#selector(animateImgLogin), with: nil, afterDelay: 1.5)
    }
    
    @objc private func animateLabels() {
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.intermarketLabel.isHidden = false
                            self.loginTitle.isHidden = false
                            self.loginSubtitle.isHidden = false
                          })
    }
    
    @objc private func animateButtons() {
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.signInGoogleButton.isHidden = false
                            self.signInFacebook.isHidden = false
                            self.signInAppleButton.isHidden = false
                          })
    }
    
    @objc private func animateImgLogin() {
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.imgLogin.isHidden = false
                          })
    }
    
}


