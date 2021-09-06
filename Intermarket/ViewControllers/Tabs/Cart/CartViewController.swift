//
//  CartViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import UIKit

class CartViewController: UIViewController {

    static let identifier = String(describing: CartViewController.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var products = [DetailProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProductUserDefaults()
        checkEmptyCart()
    }
    
    private func setupUI() {
        checkEmptyCart()
        buttonUI()
    }
    
    private func checkEmptyCart() {
        if products.count > 0 {
            titleLabel.isHidden = true
            imgSearch.isHidden = true
        }
    }
    
    private func buttonUI() {
        button.layer.borderColor = Colors.Secondary?.cgColor
    }
    
    func getProductUserDefaults() {
        let data = UserDefaultsManager.sharedInstance.getProductInCar()
        products = data
        setupUI()
    }
    
}
