//
//  SceneDelegate.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import UIKit
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let isLogged = getUserDefaultsLoggedUser()
        let onBoardingCheck = getUserDefaultsOnboardingCheck()
        
        switch (onBoardingCheck, isLogged) {
        case (onBoardingCheck == nil, isLogged == nil) :
            setupViewController(forController: OnboardingViewController(), forWindowScene: windowScene, forWindow: window)
        case (onBoardingCheck == true, isLogged == nil):
            setupViewController(forController: LoginViewController(), forWindowScene: windowScene, forWindow: window)
        case (onBoardingCheck == true, isLogged == true):
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            setupViewController(forController: destinationVC, forWindowScene: windowScene, forWindow: window)
        default:
            break
        }
        
    }
    
    func setupViewController(forController controller: UIViewController, forWindowScene windowScene: UIWindowScene, forWindow window: UIWindow ) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func getUserDefaultsLoggedUser() -> Bool? {
        guard let isLoggedUser = userDefaults.object(forKey: UserDefaultsKeys.LoggedUser) else { return false }
        return isLoggedUser as? Bool
    }
    
    func getUserDefaultsOnboardingCheck() -> Bool? {
        guard let onboardingCheck = userDefaults.object(forKey: UserDefaultsKeys.OnboardingCheck) else { return false }
        return onboardingCheck as? Bool
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

