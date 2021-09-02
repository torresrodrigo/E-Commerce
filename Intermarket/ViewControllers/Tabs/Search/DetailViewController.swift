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
    @IBOutlet weak var quantityProduct: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
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
        setupImage(forImage: data.pictures[0].url)
        setupFeaturesProduct()
        setFavorites(forValue: value)
    }
    
    private func setupDataProduct(forProduct productData: DetailProduct) {
        guard let quantity = productData.quantity else { return }
        productTitle.text = productData.title
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
    
    private func setupFeaturesProduct() {
        setFeatures()
    }
    
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
    
    func getFeatures(forProduct productData: DetailProduct?) {
        for i in 0...8 {
            if let dataName = products?.attributes?[i].name, let dataValue = products?.attributes?[i].value {
            productFeaturesName.append(dataName)
            productFeaturesValue.append(dataValue)
            }
        }
    }
    
    private func setFeatures() {
        firstFeature.text = "\(productFeaturesName[0]): \(productFeaturesValue[0])"
        secondFeature.text = "\(productFeaturesName[1]): \(productFeaturesValue[1])"
        thirdFeature.text = "\(productFeaturesName[2]): \(productFeaturesValue[2])"
        fourthFeature.text = "\(productFeaturesName[3]): \(productFeaturesValue[3])"
        fifthFeature.text = "\(productFeaturesName[4]): \(productFeaturesValue[4])"
        sixthFeature.text = "\(productFeaturesName[5]): \(productFeaturesValue[5])"
        seventhFeature.text = "\(productFeaturesName[6]): \(productFeaturesValue[6])"
    }
    
    private func setupImage(forImage imageUrl: String?) {
        guard let path = imageUrl else { return }
        productImage.sd_setImage(with: URL(string: path))
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        guard let value = productData?.isFavorite else { return }
        let changeValue = changeValue(forValue: value)
        isFavorites = changeValue
        favoritesAction(forValue: changeValue, forId: productID)
    }
    
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
        guard let dataFavorites = FavoritesManager.sharedInstance.get(key: UserDefaultsKeys.Favorites) else { return }
        var favorites = dataFavorites
        guard let value  = isFavorites else { return }
        if value == true {
            if favorites.isEmpty == true || favorites.contains(where: {$0.id != id}) {
                guard let data = productData else { return }
                favorites.append(data)
                setFavorites(forValue: value)
                FavoritesManager.sharedInstance.set(key: UserDefaultsKeys.Favorites, value: favorites)
                delegate?.updateFavorite(forId: data.id, forValue: value)
            }
        }
        else {
            guard let data = productData else { return }
            let newFavorites = favorites.filter {$0.id != id}
            setFavorites(forValue: value)
            favorites = newFavorites
            FavoritesManager.sharedInstance.set(key: UserDefaultsKeys.Favorites, value: favorites)
            delegate?.updateFavorite(forId: data.id, forValue: value)
        }
    }
    
}

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
