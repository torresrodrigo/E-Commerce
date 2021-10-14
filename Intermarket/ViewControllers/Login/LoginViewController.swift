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

    // Apple Sign in
extension LoginViewController {

    //Apple
    private func setupAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        currentNounce = randomNonceString()
        guard let nounce = currentNounce else { return }
        request.requestedScopes = [.email]
        request.nonce = sha256(nounce)

        setupAuthorizationControllerApple(forRequest: request)
    }

    func setupAuthorizationControllerApple(forRequest request: ASAuthorizationRequest) {
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

}


extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let nounce = currentNounce {
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
            guard let appleIDToken = appleIDCredential?.identityToken else { return }
            guard let appleIDTokenString = String(data: appleIDToken, encoding: .utf8) else { return }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: nounce)
            LoginService.shared.goToMainTabBar(viewController: self, withCredential: credential, loginType: .Apple)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

}

