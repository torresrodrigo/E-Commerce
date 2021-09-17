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
    @IBOutlet weak var stackView: UIStackView!
    
    //Products added UI
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var buttonQR: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var snackBarView: UIView!
    
    var isNavigationController = false
    
    var totalPrice = 0.0
    var arrayPrices = [Double]()
    var products = [DetailProduct]()
    var productRemoved: DetailProduct?
    var totalQuantityProducts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalPrice = 0.0
        getProductUserDefaults()
        checkEmptyCart()
        checkTypeController()
        setTotalPrice()
        setTotalQuantityProducts()
        productsTableView.reloadData()
    }
    
    //Validation for products
    private func checkEmptyCart() {
        if products.count > 0 {
            addedProductUI()
            setupTableView()
        } else {
            showEmptyState()
        }
        
    }
    
    private func addedProductUI() {
        self.hideEmptyState()
        self.showButton()
    }
    
    private func hideEmptyState() {
        titleLabel.isHidden = true
        imgSearch.isHidden = true
        stackView.isHidden = false
        productsTableView.isHidden = false
        totalView.isHidden = false
        buttonQR.isHidden = false
    }
    
    private func showEmptyState() {
        titleLabel.isHidden = false
        imgSearch.isHidden = false
        stackView.isHidden = true
        productsTableView.isHidden = true
        totalView.isHidden = true
        buttonQR.isHidden = true
        buttonUI()
    }
    
    private func showButton() {
        button.borderHeight = 0
        button.isHidden = false
        button.backgroundColor = Colors.Primary
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
    }

    private func buttonUI() {
        button.layer.borderColor = Colors.Secondary?.cgColor
        button.backgroundColor = .white
        button.isEnabled = false
    }
    
    func getProductUserDefaults() {
        let data = UserDefaultsManager.sharedInstance.getProductInCar()
        products = data
    }
    
    //Validation for type of Controller to show back button
    func checkTypeController() {
        if isNavigationController == true {
            backButton.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoButton(_ sender: Any) {
        guard let product = productRemoved else {return }
        undoButtonAction(forProduct: product, useButtonAction: true)
        button.isHidden = false
    }
    
    func undoButtonAction(forProduct product: DetailProduct, useButtonAction: Bool) {
        if useButtonAction {
            products.append(product)
            UserDefaultsManager.sharedInstance.setProductInCart(value: product)
            checkEmptyCart()
            productsTableView.reloadData()
            snackBarView.isHidden = true
        } else {
            products.append(product)
            UserDefaultsManager.sharedInstance.setProductInCart(value: product)
            checkEmptyCart()
            productsTableView.reloadData()
            snackBarView.isHidden = true
        }
        setTotalPrice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPurchase" {
            let vc = segue.destination as? PurchaseViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.isNavigationController = isNavigationController
            vc?.totalPrice = totalPrice
            vc?.productsQuantityTotal = totalQuantityProducts
            vc?.productsPurchase = products
        } else if segue.identifier == "goToQrCode" {
            let vc = segue.destination as? QRCodeViewController
            vc?.modalPresentationStyle = .fullScreen
        }
    }
    
}

//MARK: - ProductsTableView
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
        return cell
    }
    
}

//MARK: - ProductsTableViewDelegate
extension CartViewController: ProductsTableViewCellDelegate {
    
    //Action Delegate
    func updateCell(forId id: String, forQuantity newQuantity: Int) {
        changeQuantity(forId: id, forQuantity: newQuantity)
        productsTableView.reloadData()
        setTotalPrice()
        setTotalQuantityProducts()
    }
    
    func changeQuantity(forId id: String, forQuantity valueQuantity: Int) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            if valueQuantity == 0 {
                products[index].quantity = 1
                deleteProductAction(forIndex: index)
                checkEmptyCart()
                snackBarUI()
                self.perform(#selector(dissappearSnackBar), with: nil, afterDelay: 4)
            } else {
                products[index].quantity = valueQuantity
            }
        }
    }
    
    //Action Delegate
    func deleteProduct(forId id: String) {
        if let i = products.firstIndex(where: {$0.id == id}) {
            deleteProductAction(forIndex: i)
            setTotalPrice()
            if products.count > 0 {
                checkProducts(isEmpty: false)
            }
            else {
                checkProducts(isEmpty: true)
            }
        }
    }
    
    func deleteProductAction(forIndex index: Int) {
        productRemoved = products[index]
        products.remove(at: index)
        productsTableView.reloadData()
        UserDefaultsManager.sharedInstance.setProductsInCart(forValue: products)
    }
    
    func checkProducts(isEmpty value: Bool) {
        if value {
            checkEmptyCart()
            snackBarUI()
            self.perform(#selector(dissappearSnackBar), with: nil, afterDelay: 4)
        }
        else {
            snackBarUI()
            self.perform(#selector(dissappearSnackBar), with: nil, afterDelay: 4)
        }
    }
    
    //SnackBar Actions
    func snackBarUI() {
        snackBarView.isHidden = false
    }
    
    @objc func dissappearSnackBar() {
        snackBarView.isHidden = true
    }
    
    //Action for price
    func setTotalPrice() {
        var prices = [Double]()
        if products.count > 0 {
            for i in 0...products.count - 1 {
                guard let quantity = products[i].quantity else { return }
                let priceProducts = Double(quantity) * products[i].price
                prices.append(priceProducts)
            }
        }
        totalPrice = prices.reduce(0, +)
        priceLabel.text = totalPrice.currency()
    }
    
    //Action for quantity
    func setTotalQuantityProducts() {
        var quantityProducts = [Int]()
        if products.count > 0 {
            for i in 0...products.count - 1 {
                guard let quantity = products[i].quantity else { return }
                quantityProducts.append(quantity)
            }
        }
        totalQuantityProducts = quantityProducts.reduce(0, +)
    }
    
}
