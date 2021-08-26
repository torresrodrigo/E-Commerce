//
//  ProductsCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import UIKit
import SDWebImage

protocol ProductCellDelegate {
    func onTouchFavorites(forProduct product: Products)
}

class ProductsCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ProductsCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsCollectionViewCell.self), bundle: nil)
    }
    
    let userDefaults = UserDefaults.standard
    var cellDelegate: ProductCellDelegate? = nil
    var product: Products?
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        removerUserDefaults()
        product?.isFavorite = false
        setupUI()
    }
    
    func setupUI() {
        setupShadow()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        changeFavoritesStatus(forStatus: product?.isFavorite)
        guard let dataProduct = product else { return }
        cellDelegate?.onTouchFavorites(forProduct: dataProduct)
    }
    
    func setupCell(data: Products) {
        titleProduct.text = data.title.maxLength(length: 30).breakLine()
        priceProduct.text = data.price.currency()
        setupImageProduct(image: data.thumbnail)
        product = data
        setFavoritesImg(forStatusImage: product?.isFavorite)
    }
    
    private func setupShadow() {
        self.layer.shadowColor = Colors.Shadow?.cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func setFavoritesImg(forStatusImage status: Bool?) {
        if let value = status {
            value ? favoriteIcon.setImage(Icons.FavoriteAdded, for: .normal) : favoriteIcon.setImage(Icons.Favorite, for: .normal)
        }
        favoriteIcon.setImage(Icons.Favorite, for: .normal)
    }
    
    private func setupImageProduct(image: String?) {
        guard let path = image else { return }
        productImg.sd_setImage(with: URL(string: path))
    }
    
    private func changeFavoritesStatus(forStatus status: Bool?) {
        if status == false || status == nil {
            product?.isFavorite = true
            favoriteIcon.setImage(Icons.FavoriteAdded, for: .normal)
        } else if status == true {
            product?.isFavorite = false
            favoriteIcon.setImage(Icons.Favorite, for: .normal)
        }
    }
    
//    func removerUserDefaults() {
//        userDefaults.removeObject(forKey: UserDefaultsKeys.Favorites)
//    }
    
//    func printProducts(forProduct product: Products) {
//        print("Id \(product.id)")
//        print("Title \(product.title)")
//        print("Price \(product.price)")
//        print("Favorites status \(product.isFavorite)")
//    }
    
}


