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
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityProduct: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
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
    var productID = String()
    var products: DetailProduct?
    var productPriceValue: String?
    var productFeaturesName = [String]()
    var productFeaturesValue = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailProduct(forId: productID)
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(forProduct productData: DetailProduct) {
        setupDataProduct(forProduct: productData)
        setupImage(forImage: productData.pictures[0].url)
        setupFeaturesProduct()
    }
    
    private func setupDataProduct(forProduct productData: DetailProduct) {
        guard let quantity = productData.quantity else { return }
        productTitle.text = productData.title
        productPrice.text = productData.price.currency()
        quantityProduct.text = "\(quantity) unidades disponibles"
    }
    
    private func setupFeaturesProduct() {
            setFeatures()
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
    
}

extension DetailViewController {
    func getDetailProduct(forId id: String) {
        NetworkService.shared.getDetailsProducts(query: id) { response in
            switch response {
            case .success(let response):
                self.products = response
                self.getFeatures(forProduct: self.products)
                print("Features Name: \(self.productFeaturesName.count)")
                print("Features Value: \(self.productFeaturesValue.count)")
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
