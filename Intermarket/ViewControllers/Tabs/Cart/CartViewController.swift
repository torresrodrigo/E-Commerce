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
        checkEmptyCartAction(forCount: products.count)
    }
    
    func checkEmptyCartAction(forCount count: Int) {
        if count > 0 {
            addedProductUI()
            setupButtonUI(isEnabled: true)
        }
        else {
            setupUI(hasProduct: false)
            setupButtonUI(isEnabled: false)
        }
    }
    
    func setupUI(hasProduct value: Bool) {
        titleLabel.isHidden = value ? true : false
        imgSearch.isHidden = value ? true : false
        stackView.isHidden = value ? false : true
        productsTableView.isHidden = value ? false : true
        totalView.isHidden = value ? false : true
        buttonQR.isHidden = value ? false : true
    }
    
    private func addedProductUI() {
        self.setupUI(hasProduct: true)
        self.setupTableView()
        self.enabledButton()
    }

    func setupButtonUI(isEnabled value: Bool) {
        if value {
            enabledButton()
        }
        else {
            disabledButton()
        }
    }
    
    private func enabledButton() {
        button.borderHeight = 0
        button.isHidden = false
        button.backgroundColor = Colors.Primary
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
    }

    private func disabledButton() {
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
            reAddProduct(forProduct: product)
        }
        setTotalPrice()
    }
    
    func reAddProduct(forProduct product: DetailProduct) {
        products.append(product)
        UserDefaultsManager.sharedInstance.setProductInCart(value: product)
        checkEmptyCart()
        productsTableView.reloadData()
        snackBarView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareAction(forSegue: segue)
    }
    
    private func prepareAction(forSegue segue: UIStoryboardSegue) {
        if segue.identifier == "goToPurchase" {
            goToPurchaseVC(forSegue: segue)
        } else if segue.identifier == "goToQrCode" {
            goToQrCodeVC(forSegue: segue)
        }
    }
    
    private func goToPurchaseVC(forSegue segue: UIStoryboardSegue) {
        let vc = segue.destination as? PurchaseViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.isNavigationController = isNavigationController
        vc?.totalPrice = totalPrice
        vc?.productsQuantityTotal = totalQuantityProducts
        vc?.productsPurchase = products
    }
    
    private func goToQrCodeVC(forSegue segue: UIStoryboardSegue) {
        let vc = segue.destination as? QRCodeViewController
        vc?.modalPresentationStyle = .fullScreen
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
    func updateCell(forId id: String, forQuantity newQuantity: Int, forTotalQuantity totalQuantity: Int) {
        changeQuantity(forId: id, forQuantity: newQuantity, maxQuantity: totalQuantity)
        productsTableView.reloadData()
        setTotalPrice()
        setTotalQuantityProducts()
    }
    
    func changeQuantity(forId id: String, forQuantity valueQuantity: Int, maxQuantity: Int) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            if valueQuantity == 0 {
                products[index].quantity = 1
                deleteProductAction(forIndex: index)
                checkEmptyCart()
                snackBarUI()
                self.perform(#selector(dissappearSnackBar), with: nil, afterDelay: 4)
            }
            else if valueQuantity == maxQuantity {
                showAlert()
            }
            else {
                products[index].quantity = valueQuantity
            }
        }
    }
    
//    func saveProductQuantity(forProduct productData: DetailProduct, forQuantity quantity: Int) {
//        UserDefaultsManager.sharedInstance.setProductsInCart(forValue: <#T##[DetailProduct]#>)
//    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No hay mas articulos disponiles", message: "Esta es la cantidad maxima de articulos", preferredStyle: .alert)
        let action = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
