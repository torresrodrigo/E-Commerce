//
//  LoginService.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/10/2021.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FacebookLogin
import AuthenticationServices
import CryptoKit
import GoogleSignIn

enum LoginType: String{
    case Google
    case Apple
    case Facebook
}

final class LoginService: NSObject {
    
    static let shared = LoginService()
    var currentNounce: String?
    
}

//Sign in Google
extension LoginService {
    
    func loginGoogle(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [weak self] user, error in
            if let error = error {
                print("Some error: \(error)")
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            self?.goToMainTabBar(viewController: viewController, withCredential: credential, loginType: .Google)
        }
    }
    
}

//Sign in Facecebook
extension LoginService {
    
    func loginFacebook(viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: viewController) { (result) in

            switch result {
            case .success(granted: let granted, declined: let declined, token: let token):
                guard let tokenString = token?.tokenString else { return }
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                self.goToMainTabBar(viewController: viewController, withCredential: credential, loginType: .Facebook)
            case .cancelled:
                print("Cancelled")
            case .failed(_):
                print("Failed")
            }
        }
    }
    
}

//Controllers
extension LoginService {
    
    func goToMainTabBar(viewController: UIViewController?, withCredential credential: AuthCredential, loginType: LoginType) {
        guard let vc = viewController else { return }
        Auth.auth().signIn(with: credential) { authResult, error in
            print("Logged User !!")
            UserDefaultsManager.sharedInstance.setLoggedUser()
            UserDefaultsManager.sharedInstance.setLoginType(loginType: loginType)
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            self.setupRootViewController(firstVC: vc, secondVC: destinationVC)
        }
    }
    
    private func setupRootViewController(firstVC: UIViewController, secondVC: UIViewController) {
        guard let window = firstVC.view.window else { return }
        window.rootViewController = secondVC
        window.makeKeyAndVisible()
        animationChangeView(forWindow: window)
    }
    
    private func animationChangeView(forWindow window: UIWindow) {
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
}
