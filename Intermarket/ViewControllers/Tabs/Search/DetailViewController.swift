//
//  DetailViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 30/08/2021.
//

import UIKit
import SDWebImage

protocol DetailViewControllerDelegate {
    func updateFavorite(forId id: String, forValue value: Bool)
}

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
    var delegate: DetailViewControllerDelegate?
    var productID = String()
    var productData: Products?
    var products: DetailProduct?
    var isFavorites: Bool?
    var productPriceValue: String?
    var productFeaturesName = [[String]]()
    var productFeaturesValue = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromSearchViewController(forData: productData)
        getDetailProduct(forId: productData?.id)
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(forProduct data: DetailProduct) {
        guard let value = productData?.isFavorite else { return }
        setupScrollView()
        setupDataProduct(forProduct: data)
        setupFeaturesProduct()
        setFavorites(forValue: value)
        setupTableView()
        setupCollectionView()
    }
    
    private func setupDataProduct(forProduct productData: DetailProduct) {
        guard let quantity = productData.quantityAvaibable else { return }
        guard let hasDescription = productData.subtitle != nil ? true : false else { return }
        productTitle.text = productData.title
        productDescription.text = hasDescription ? productData.subtitle : "Not description"
        productPrice.text = productData.price.currency()
        quantityProduct.text = "\(quantity) unidades disponibles"
    }
    
    func getDataFromSearchViewController(forData data: Products?) {
        guard let productData = data else { return }
        productID = productData.id
        isFavorites = productData.isFavorite
        productPriceValue = productData.price.currency()
    }
    
    private func setupScrollView() {
        scrollView.bounces = false
    }
    
    func getFeatures(forData data: DetailProduct) {
        
    }
    
    //Set favorite icon value
    private func setFavorites(forValue value: Bool) {
        if value == true {
            favoritesButton.setImage(Icons.FavoriteAdded, for: .normal)
            productData?.isFavorite = value
        }
        else {
            favoritesButton.setImage(Icons.Favorite, for: .normal)
            productData?.isFavorite = value
        }
    }
    
    //Set feaures of products - CHECK
    private func setupFeaturesProduct() {
        
    }

    //Button Action when favorites change value
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        guard let value = productData?.isFavorite else { return }
        let changeValue = changeValue(forValue: value)
        isFavorites = changeValue
        favoritesAction(forValue: changeValue, forId: productID)
    }
    
    //Change value to favorite icon
    func changeValue(forValue value: Bool) -> Bool {
        let valueFinal: Bool
        if value == true {
            valueFinal = false
        }
        else {
            valueFinal = true
        }
        return valueFinal
    }
    
    func favoritesAction(forValue value: Bool, forId id: String) {
        guard let dataFavorites = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        var favorites = dataFavorites
        guard let value  = isFavorites else { return }
        if value == true {
            if favorites.isEmpty == true || favorites.contains(where: {$0.id != id}) {
                guard let data = productData else { return }
                favorites.append(data)
                setFavorites(forValue: value)
                UserDefaultsManager.sharedInstance.setFavorites(value: favorites)
                delegate?.updateFavorite(forId: data.id, forValue: value)
            }
        }
        else {
            guard let data = productData else { return }
            let newFavorites = favorites.filter {$0.id != id}
            setFavorites(forValue: value)
            favorites = newFavorites
            UserDefaultsManager.sharedInstance.setFavorites(value: favorites)
            delegate?.updateFavorite(forId: data.id, forValue: value)
        }
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        addToCartAction()
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
    
    func getDetailProduct(forId id: String?) {
        guard let dataId = id else { return }
        NetworkService.shared.getDetailsProducts(query: dataId) { response in
            switch response {
            case .success(let response):
                self.products = response
                DispatchQueue.main.async {
                    guard let data = self.products else { return }
                    self.setupUI(forProduct: data)
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
        featuresTableView.sectionIndexColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let section = setSections()
        return section
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        setNameSections(sectionsCount: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = setRowForSection(forSections: section)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = featuresTableView.dequeueReusableCell(withIdentifier: FeaturesTableViewCell.identifier, for: indexPath) as! FeaturesTableViewCell
        cell = setCell(forSection: indexPath.section, forIndex: indexPath.row, forCell: cell)
        return cell
    }
    
    private func setCell(forSection section: Int, forIndex indexPath: Int, forCell cell: FeaturesTableViewCell) -> FeaturesTableViewCell {
        if let attributes = products?.attributes {
            if section == 0 {
                cell.setupCell(forFeatureName: attributes[indexPath].name, forFeatureValue: attributes[indexPath].value)
            } else {
                cell.setupCell(forFeatureName: attributes[indexPath + 5].name, forFeatureValue: attributes[indexPath + 5].value)
            }
        }
        return cell
    }
    
    func setSections() -> Int {
        var count: Int
        guard let attributes = products?.attributes?.count else { return 0 }
        if attributes > 5 {
            count = 2
        } else {
            count = 1
        }
        return count
    }
    
    func setNameSections(sectionsCount value: Int) -> String {
        if value == 0 {
            return "Caracteristicas"
        } else {
            return "Info adicional"
        }
    }
    
    func setRowForSection(forSections value: Int) -> Int {
        guard let attributes = products?.attributes?.count else { return 0 }
        if value == 0 {
            if attributes > 5 {
                return 5
            } else {
                return attributes
            }
        } else {
            if attributes > 7 {
                return 2
            } else {
                return 1
            }
        }
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
