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
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalPrice = 0.0
        getProductUserDefaults()
        checkTypeController()
        checkEmptyCart()
        setTotalPrice()
        setTotalQuantityProducts()
        productsTableView.reloadData()
    }
    
    //Validation for products
    private func checkEmptyCart() {
        checkEmptyCartAction(count: products.count)
    }
    
    func checkEmptyCartAction(count: Int) {
        if count > 0 {
            addedProductUI()
            setupButtonUI(isEnabled: true)
        }
        else {
            setupUI(isProductEmpty: false)
            setupButtonUI(isEnabled: false)
        }
    }
    
    func setupUI(isProductEmpty: Bool) {
        titleLabel.isHidden = isProductEmpty
        imgSearch.isHidden = isProductEmpty
        stackView.isHidden = !isProductEmpty
        productsTableView.isHidden = !isProductEmpty
        totalView.isHidden = !isProductEmpty
        buttonQR.isHidden = !isProductEmpty
    }
    
    private func addedProductUI() {
        self.setupUI(isProductEmpty: true)
        self.setupTableView()
        self.enabledButton()
    }

    func setupButtonUI(isEnabled: Bool) {
        isEnabled ? enabledButton() : disabledButton()
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
        if !isNavigationController  {
            backButton.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoButton(_ sender: Any) {
        guard let product = productRemoved else {return }
        undoButtonAction(product: product, useButtonAction: true)
        button.isHidden = false
    }
    
    func undoButtonAction(product: DetailProduct, useButtonAction: Bool) {
        useButtonAction ? reAddProduct(previousProduct: product) : nil
        setTotalPrice()
    }
    
    func reAddProduct(previousProduct: DetailProduct) {
        products.append(previousProduct)
        UserDefaultsManager.sharedInstance.setProductInCart(dataProduct: previousProduct)
        checkEmptyCart()
        productsTableView.reloadData()
        snackBarView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareAction(segue: segue)
    }
    
    private func prepareAction(segue: UIStoryboardSegue) {
        if segue.identifier == Identifier.GoToPurchase {
            goToPurchaseVC(segue: segue)
        } else if segue.identifier == Identifier.GoToQRCode {
            goToQrCodeVC(segue: segue)
        }
    }
    
    private func goToPurchaseVC(segue: UIStoryboardSegue) {
        let vc = segue.destination as? PurchaseViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.isNavigationController = isNavigationController
        vc?.totalPrice = totalPrice
        vc?.productsQuantityTotal = totalQuantityProducts
        vc?.productsPurchase = products
    }
    
    private func goToQrCodeVC(segue: UIStoryboardSegue) {
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
        cell.setupCell(data: products[indexPath.row])
        return cell
    }
    
}

//MARK: - ProductsTableViewDelegate
extension CartViewController: ProductsTableViewCellDelegate {
    
    //Action Delegate
    func updateCell(id: String, newQuantity: Int, maxQuantity: Int) {
        changeQuantity(id: id, valueQuantity: newQuantity, maxQuantity: maxQuantity)
        productsTableView.reloadData()
        setTotalPrice()
        setTotalQuantityProducts()
    }
    
    func changeQuantity(id: String, valueQuantity: Int, maxQuantity: Int) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            switch valueQuantity {
            case 0:
                products[index].quantity = 1
                deleteProductAction(index: index)
            case maxQuantity:
                showAlert()
            default:
                products[index].quantity = valueQuantity
             }
        }
        saveProductQuantity(productData: products)
    }
    
    func saveProductQuantity(productData: [DetailProduct]) {
        UserDefaultsManager.sharedInstance.setProductsInCart(totalProductsData: productData)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No hay mas articulos disponibles", message: "Esta es la cantidad maxima de articulos", preferredStyle: .alert)
        let action = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Action Delegate
    func deleteProduct(id: String) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            deleteProductAction(index: index)
            setTotalPrice()
            productsTableView.reloadData()
        }
    }
    
    func deleteProductAction(index: Int) {
        productRemoved = products[index]
        products.remove(at: index)
        UserDefaultsManager.sharedInstance.setProductsInCart(totalProductsData: products)
        products.count > 0 ? checkProducts(isEmpty: false) : checkProducts(isEmpty: true)
    }
    
    
    func checkProducts(isEmpty: Bool) {
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
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(dissappearSnackBar), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //SnackBar Actions
    func snackBarUI() {
        stopTimer()
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
