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
    
    //Outlets Caracteristicas
    @IBOutlet weak var firstFeature: UILabel!
    @IBOutlet weak var secondFeature: UILabel!
    @IBOutlet weak var thirdFeature: UILabel!
    @IBOutlet weak var fourthFeature: UILabel!
    @IBOutlet weak var fifthFeature: UILabel!
    
    //Outlets InfoAdicional
    @IBOutlet weak var sixthFeature: UILabel!
    @IBOutlet weak var seventhFeature: UILabel!
    
    static let identifier = String(describing: DetailViewController.self)
    var delegate: DetailViewControllerDelegate?
    var productID = String()
    var productData: Products?
    var products: DetailProduct?
    var isFavorites: Bool?
    var productPriceValue: String?
    var productFeaturesName = [String]()
    var productFeaturesValue = [String]()

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
        setFeatures()
    }
    
    func getFeatures(forProduct productData: DetailProduct?) {
        guard let attributes = products?.attributes else { return }
        for i in 0...7 {
            guard let dataValue = attributes[i].value else { return }
            let dataName = attributes[i].name
            productFeaturesName.append(dataName)
            productFeaturesValue.append(dataValue)
        }
    }
    
    //CHECK
    private func setFeatures() {
        firstFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 0)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 0))"
        secondFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 1)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 1))"
        thirdFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 2)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 2))"
        fourthFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 3)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 3))"
        fifthFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 4)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 4))"
        sixthFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 5)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 5))"
        seventhFeature.text = "\(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesName, forIndex: 6)): \(checkFeaturesIsEmpty(forFeaturesArray: productFeaturesValue, forIndex: 6))"
    }
    
    func checkFeaturesIsEmpty(forFeaturesArray array: [String]?, forIndex index: Int) -> String {
        guard let data = array else { return "Not features" }
        let features = data
        var text = String()
        if features.isEmpty {
            text = "Not features"
        }
        else {
            text = "\(features[index])"
        }
        return text
        
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
                self.getFeatures(forProduct: self.products)
                DispatchQueue.main.async {
                    guard let data = self.products else { return }
                    self.setupUI(forProduct: data)
                }
            case .failure(let error):
                print("Something is wrong. Error \(error.localizedDescription)")
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
