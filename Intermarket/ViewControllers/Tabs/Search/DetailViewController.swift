//
//  DetailViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 30/08/2021.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var quantityProduct: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var snackBarView: UIView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var featuresTableView: UITableView!

    //Propierties
    static let identifier = String(describing: DetailViewController.self)
    var productID = String()
    var productData: Products?
    var products: DetailProduct?
    var isFavorites: Bool?
    var productPriceValue: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromSearchViewController(with: productData)
        getDetailProduct(with: productData?.id)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(with data: DetailProduct) {
        guard let value = productData?.isFavorite else { return }
        setupScrollView()
        setupDataProduct(with: data)
        setFavoritesIcon(for: value)
        setupTableView()
        setupCollectionView()
    }
    
    private func setupDataProduct(with productData: DetailProduct) {
        guard let quantity = productData.quantityAvaibable else { return }
        guard let hasDescription = productData.subtitle != nil ? true : false else { return }
        productTitle.text = productData.title
        productDescription.text = hasDescription ? productData.subtitle : "Not description"
        productPrice.text = productData.price.currency()
        quantityProduct.text = "\(quantity) unidades disponibles"
    }
    
    func getDataFromSearchViewController(with data: Products?) {
        guard let productData = data else { return }
        productID = productData.id
        isFavorites = productData.isFavorite
        productPriceValue = productData.price.currency()
    }
    
    private func setupScrollView() {
        scrollView.bounces = false
    }
    
    //Set favorite icon value
    private func setFavoritesIcon(for value: Bool) {
        value ? addIconAdded(for: value) : removeIconAdded(for: value)
    }
    
    func addIconAdded(for value: Bool) {
        favoritesButton.setImage(Icons.FavoriteAdded, for: .normal)
        productData?.isFavorite = value
    }
    
    func removeIconAdded(for value: Bool) {
        favoritesButton.setImage(Icons.Favorite, for: .normal)
        productData?.isFavorite = value
    }
    

    //Button Action when favorites change value
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        guard let value = productData?.isFavorite else { return }
        favoritesButtonAction(for: value)
    }
    
    func favoritesButtonAction(for value: Bool) {
        let finalValue = changeValue(with: value)
        isFavorites = finalValue
        setFavorites(with: finalValue, with: productID)
    }
    
    //Change value to favorite icon
    func changeValue(with value: Bool) -> Bool {
        return value ? false : true
    }
    
    //Abstraer
    func setFavorites(with value: Bool, with id: String) {
        guard let dataFavorites = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        var favorites = dataFavorites
        guard let value = isFavorites else { return }
        if value == true {
            if favorites.isEmpty == true || favorites.contains(where: {$0.id != id}) {
                setFavoritesIcon(for: value)
                guard let data = productData else { return }
                favorites.append(data)
                UserDefaultsManager.sharedInstance.setFavorites(value: favorites)
                notificationToSearch(for: id, for: value)
            }
        }
        else {
            let newFavorites = favorites.filter {$0.id != id}
            setFavoritesIcon(for: value)
            favorites = newFavorites
            UserDefaultsManager.sharedInstance.setFavorites(value: favorites)
            notificationToSearch(for: id, for: value)
        }
    }
    
    func notificationToSearch(for id: String, for value: Bool) {
        let dict: [String : Any] = ["id" : id, "value" : value]
        let notification = Notification.Name(rawValue: NotificationsKeys.Search)
        NotificationCenter.default.post(name: notification, object: dict)
    }
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
        validateProduct(for: products)
        self.perform(#selector(dissapearSnackBar),with: nil,afterDelay: 3)
    }
    
    //Add products in to cart
    func addToCartAction() {
        products?.quantity = 1
        guard let data = products else { return }
        snackBarView.isHidden = false
        addToCartButton.isHidden = true
        UserDefaultsManager.sharedInstance.setProductInCart(value: data)
    }
    
    func validateProduct(for product: DetailProduct?) {
        guard let data = product else { return }
        let dataProductsCart = UserDefaultsManager.sharedInstance.getProductInCar()
        dataProductsCart.contains(where: {$0.id == data.id}) ? showAlertAddProduct() : addToCartAction()
    }
    
    private func showAlertAddProduct() {
        let alert = UIAlertController(title: "Este producto ya esta agregado a tu carrito", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func dissapearSnackBar() {
        snackBarView.isHidden = true
    }
    
    //Push to CartViewController
    @IBAction func goToCartPressed(_ sender: Any) {
        goToCartAction()
    }
    
    func goToCartAction() {
        let storyboard = UIStoryboard(name: "CartStoryboard", bundle: nil)
        let cartVC = storyboard.instantiateViewController(withIdentifier: CartViewController.identifier) as! CartViewController
        cartVC.isNavigationController = true
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true, completion: nil)
    }
}

//MARK: - API CALL
extension DetailViewController {
    
    func getDetailProduct(with id: String?) {
        guard let dataId = id else { return }
        NetworkService.shared.getDetailsProducts(query: dataId) { response in
            switch response {
            case .success(let response):
                self.products = response
                DispatchQueue.main.async {
                    guard let data = self.products else { return }
                    self.setupUI(with: data)
                    self.featuresTableView.reloadData()
                }
            case .failure(let error):
                print("Something is wrong. Error \(error.localizedDescription)")
            }
        }
    }
    
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        featuresTableView.register(FeaturesTableViewCell.nib(), forCellReuseIdentifier: FeaturesTableViewCell.identifier)
        featuresTableView.dataSource = self
        featuresTableView.delegate = self
        featuresTableView.isScrollEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let section = setSections()
        return section
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        setNameSections(with: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Colors.TextCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = setRowForSection(for: section)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = featuresTableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.identifier, for: indexPath) as! FeaturesTableViewCell
        cell = setCell(for: indexPath.section, for: indexPath.row, for: cell)
        return cell
    }
    
    private func setCell(for section: Int, for indexPath: Int, for cell: FeaturesTableViewCell) -> FeaturesTableViewCell {
        if let attributes = products?.attributes {
            section == 0 ? cell.setupCell(for: attributes[indexPath].name, for: attributes[indexPath].value) : cell.setupCell(for: attributes[indexPath + 5].name, for: attributes[indexPath + 5].value)
        }
        return cell
    }
    
    //Set quantity of Section TableView
    func setSections() -> Int {
        guard let attributes = products?.attributes?.count else { return 0 }
        let count = (attributes > 5) ? 2 : 1
        return count
    }
    
    //Set Name of Section TableView
    func setNameSections(with value: Int) -> String {
        value == 0 ? "Caracteristicas" : "Info adicional"
    }
    
    //Set quantity of row for Section TableView
    func setRowForSection(for row: Int) -> Int {
        guard let attributes = products?.attributes?.count else { return 0 }
        let row = (row == 0) ? checkFeatures(with: attributes) :  checkInfoAdditional(with: attributes)
        return row
    }
    
    //Set quantity of Section Features
    func checkFeatures(with attributes: Int) -> Int {
        let count = (attributes > 5) ? 5 : attributes
        return count
    }
    
    //Set quantity of Section InfoAdditional
    func checkInfoAdditional(with attributes: Int) -> Int{
        let count = (attributes > 7) ? 2 : 1
        return count
    }
}


//MARK: - ImagesCollectionView
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        imagesCollectionView.register(ImgDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: ImgDetailCollectionViewCell.identifier)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.bounces = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = products?.pictures.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: ImgDetailCollectionViewCell.identifier, for: indexPath) as! ImgDetailCollectionViewCell
        guard let count = products?.pictures.count else { return cell }
        let textLabel = "\(indexPath.row + 1)/\(count)"
        cell.setupCell(forImage: products?.pictures[indexPath.row].url, forCount: textLabel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(collectionView.frame.width), height: Int(collectionView.frame.height))
    }
    
}
