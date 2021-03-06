//
//  ConfirmationViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 08/09/2021.
//

import UIKit

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var imgConfirmation: UIImageView!
    @IBOutlet weak var labelConfirmation: UILabel!
    
    var isNavigationController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changeImg()
    }
    
    func setupUI() {
        imgConfirmation.loadGif(name: "480px-Loader")
    }
    
    private func changeImg() {
        self.perform(#selector(changeImgAction), with: nil, afterDelay: 3)
    }
    
    @objc func changeImgAction() {
        imgConfirmation.image = Images.Confirmation
        labelConfirmation.text = "Pedido enviado"
        self.perform(#selector(changeControllerAction), with: nil, afterDelay: 2)
    }
    
    @objc private func changeControllerAction() {
        setViewController()
    }
    
    func setViewController() {
        if isNavigationController {
            changeToCartView()
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func changeToCartView() {
        let storyboard = UIStoryboard(name: Identifier.TabBarStoryboard, bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: Identifier.TabBarController) as! MainTabViewController
        tabBar.selectedIndex = 2
        self.view.window?.rootViewController = tabBar
        self.view.window?.makeKeyAndVisible()
    }

}
