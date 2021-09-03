//
//  CartViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import UIKit

class CartViewController: UIViewController {

    static let identifier = String(describing: CartViewController.self)
    @IBOutlet weak var labelCount: UILabel!
    
    var products = [DetailProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProductUserDefaults()
    }
    
    func setupUI() {
        labelCount.text = "Products \(products.count)"
    }
    
    func getProductUserDefaults() {
        let data = UserDefaultsManager.sharedInstance.getProductInCar()
        products = data
        setupUI()
    }
    
}
