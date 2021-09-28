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
        checkEmptyCartAction(for: products.count)
    }
    
    func checkEmptyCartAction(for count: Int) {
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
        titleLabel.isHidden = value
        imgSearch.isHidden = value
        stackView.isHidden = !value
        productsTableView.isHidden = !value
        totalView.isHidden = !value
        buttonQR.isHidden = !value
    }
    
    private func addedProductUI() {
        self.setupUI(hasProduct: true)
        self.setupTableView()
        self.enabledButton()
    }

    func setupButtonUI(isEnabled value: Bool) {
        value ? enabledButton() : disabledButton()
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
        if isNavigationController == false {
            backButton.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoButton(_ sender: Any) {
        guard let product = productRemoved else {return }
        undoButtonAction(with: product, for: true)
        button.isHidden = false
    }
    
    func undoButtonAction(with product: DetailProduct, for useButtonAction: Bool) {
        useButtonAction ? reAddProduct(with: product) : nil
        setTotalPrice()
    }
    
    func reAddProduct(with product: DetailProduct) {
        products.append(product)
        UserDefaultsManager.sharedInstance.setProductInCart(value: product)
        checkEmptyCart()
        productsTableView.reloadData()
        snackBarView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareAction(for: segue)
    }
    
    private func prepareAction(for segue: UIStoryboardSegue) {
        if segue.identifier == Identifier.GoToPurchase {
            goToPurchaseVC(for: segue)
        } else if segue.identifier == Identifier.GoToQRCode {
            goToQrCodeVC(for: segue)
        }
    }
    
    private func goToPurchaseVC(for segue: UIStoryboardSegue) {
        let vc = segue.destination as? PurchaseViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.isNavigationController = isNavigationController
        vc?.totalPrice = totalPrice
        vc?.productsQuantityTotal = totalQuantityProducts
        vc?.productsPurchase = products
    }
    
    private func goToQrCodeVC(for segue: UIStoryboardSegue) {
        let vc = segue.destination as? QRCodeViewController
        vc?.isNavigationController = isNavigationController
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
         return "Productos elegidos"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as! ProductsTableViewCell
        cell.delegate = self
        cell.setupCell(for: products[indexPath.row])
        return cell
    }
    
}

//MARK: - ProductsTableViewDelegate
extension CartViewController: ProductsTableViewCellDelegate {
    
    //Action Delegate
    func updateCell(id: String, newQuantity: Int, maxQuantity: Int) {
        changeQuantity(for: id, valueQuantity: newQuantity, maxQuantity: maxQuantity)
        productsTableView.reloadData()
        setTotalPrice()
        setTotalQuantityProducts()
    }
    
    //MARK- Mejorar
    func changeQuantity(for id: String, valueQuantity: Int, maxQuantity: Int) {
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
        saveProductQuantity(with: products)
        
    }
    
    func saveProductQuantity(with productData: [DetailProduct]) {
        UserDefaultsManager.sharedInstance.setProductsInCart(forValue: productData)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No hay mas articulos disponibles", message: "Esta es la cantidad maxima de articulos", preferredStyle: .alert)
        let action = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Action Delegate - Mejorar
    func deleteProduct(id: String) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            deleteProductAction(forIndex: index)
            setTotalPrice()
            products.count > 0 ? checkProducts(for: false) : checkProducts(for: true)
        }
    }
    
    func deleteProductAction(forIndex index: Int) {
        productRemoved = products[index]
        products.remove(at: index)
        productsTableView.reloadData()
        UserDefaultsManager.sharedInstance.setProductsInCart(forValue: products)
    }
    
    //Mejorar
    func checkProducts(for isEmpty: Bool) {
        if isEmpty {
            checkEmptyCart()
            snackBarUI()
            timerSnackbar()
        }
        else {
            snackBarUI()
            timerSnackbar()
        }
    }
    
    func timerSnackbar() {
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(dissappearSnackBar), userInfo: nil, repeats: false)
    }
    
    //SnackBar Actions
    func snackBarUI() {
        snackBarView.isHidden = false
    }
    
    @objc func dissappearSnackBar() {
        snackBarView.isHidden = true
    }
    
    //Action for price - Mejorar
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
