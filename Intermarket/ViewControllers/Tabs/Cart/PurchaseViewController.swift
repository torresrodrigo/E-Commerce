//
//  PurchaseViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 07/09/2021.
//

import UIKit

class PurchaseViewController: UIViewController {

    //UI Components
    @IBOutlet weak var productsQuantity: UILabel!
    @IBOutlet weak var productsTotalPrice: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    
    var isNavigationController = false
    var productsPurchase = [DetailProduct]()
    var productsQuantityTotal = Int()
    var totalPrice = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //Actions
    @IBAction func backButton(_ sender: Any) {
        if isNavigationController == false {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        productsTotalPrice.text = "Pagás \(totalPrice.currency())"
        productsQuantity.text = "\(productsQuantityTotal) productos"
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToConfirmation" {
            let vc = segue.destination as? ConfirmationViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.isNavigationController = isNavigationController
            UserDefaultsManager.sharedInstance.remove(key: UserDefaultsKeys.ProductInCart)
        }
    }
    
}

extension PurchaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        productsTableView.register(PurchaseTableViewCell.nib(), forCellReuseIdentifier: PurchaseTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.rowHeight = 150
        productsTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsPurchase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.identifier, for: indexPath) as! PurchaseTableViewCell
        cell.setupCell(forData: productsPurchase[indexPath.row])
        return cell
    }
    
}
