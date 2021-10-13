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
    
    var imageSelected: UIImage?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupImageProfile()
    }
    
    private func setupUI() {
        self.imagePicker.delegate = self
        setupImageProfile()
        setupButton()
    }
    
    private func setupImageProfile() {
        guard let data = imageSelected else { return }
        imageProfile.maskCircle(anyImage: data)
    }
    
    private func setupButton() {
        changePhotoButton.isEnabled = true
    }
    
    private func getImage() {
        let img = UserDefaultsManager.sharedInstance.getImage()
        imageSelected = img
        imageProfile.image = imageSelected
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        changePhotoButtonAction()
    }
    
    func changePhotoButtonAction() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capure")
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate - UINavigationControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Open a gallery photos
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        UserDefaultsManager.sharedInstance.setImage(image: chosenImage)
        imageProfile.maskCircle(anyImage: chosenImage)
        dismiss(animated: true, completion: nil)
    }
    
}
