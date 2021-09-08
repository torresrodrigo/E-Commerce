//
//  CartViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import UIKit

class CartViewController: UIViewController {

    static let identifier = String(describing: CartViewController.self)
    
    //Empty state components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //Products added UI
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var buttonQR: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var isNavigationController = false
    
    var totalPrice = 0.0
    var arrayPrices = [Double]()
    var products = [DetailProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalPrice = 0.0
        getProductUserDefaults()
        checkEmptyCart()
        checkTypeController()
        setupTableView()
        productsTableView.reloadData()
    }
    
    private func setupUI() {
        checkEmptyCart()
        setupTableView()
        checkTypeController()
        buttonUI()
    }
    
    private func checkEmptyCart() {
        if products.count > 0 {
            addedProductUI()
        }
    }
    
    private func addedProductUI() {
        DispatchQueue.main.async {
            self.hideEmptyState()
            self.showButton()
        }
    }
    
    private func hideEmptyState() {
        titleLabel.isHidden = true
        imgSearch.isHidden = true
        productsTableView.isHidden = false
        totalView.isHidden = false
        buttonQR.isHidden = false
    }
    
    private func showButton() {
        button.borderHeight = 0
        button.backgroundColor = Colors.Primary
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
    }

    
    private func buttonUI() {
        button.layer.borderColor = Colors.Secondary?.cgColor
        button.isEnabled = false
    }
    
    func getProductUserDefaults() {
        let data = UserDefaultsManager.sharedInstance.getProductInCar()
        products = data
        setupUI()
    }
    
    
    func checkTypeController() {
        if isNavigationController == true {
            backButton.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPurchase" {
            let vc = segue.destination as? PurchaseViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.isNavigationController = isNavigationController
            vc?.totalPrice = totalPrice
            vc?.productsQuantityTotal = products.count
            vc?.productsPurchase = products
        }
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        productsTableView.register(ProductsTableViewCell.nib(), forCellReuseIdentifier: ProductsTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         switch section {
         case 0: return "Productos elegidos"
         default: return nil
         }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as! ProductsTableViewCell
        cell.delegate = self
        cell.setupCell(forData: products[indexPath.row])
        products[indexPath.row].quantity = cell.quantity
        totalPrice = totalPrice + cell.totalPrice
        priceLabel.text = totalPrice.currency()
        return cell
    }
    
}

extension CartViewController: ProductsTableViewCellDelegate {
    
    func updatePrice() {
        totalPrice = 0
        productsTableView.reloadData()
    }
    
    func setPrice(forArrayPrice array: [Double]) -> Double {
        var total = Double()
        if array.count > 0 {
            for i in 0...array.count - 1 {
                total = total + array[i]
            }
        }
        return total
    }
    
}
