//
//  ProfileViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 15/09/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    private func setupUI() {
        setupImageProfile()
        setupButton()
    }
    
    private func setupImageProfile() {
        imageProfile.layer.borderWidth = 2
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
        imageProfile.clipsToBounds = false
    }
    
    private func setupButton() {
        changePhotoButton.isEnabled = true
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        
    }
}
