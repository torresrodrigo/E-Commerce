//
//  ProductsCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import UIKit
import SDWebImage

protocol ProductCellDelegate {
    func onTouchFavorites(forValue value: Bool, forId id: String)
}

class ProductsCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ProductsCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsCollectionViewCell.self), bundle: nil)
    }
    
    var cellDelegate: ProductCellDelegate? = nil
    var isFavorite: Bool?
    var idCell: String?
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        setupShadow()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let valueFavorite = isFavorite, let valueId = idCell {
            let changeValueFavorite = valueFavorite == false ? true : false
            isFavorite = changeValueFavorite
            setFavoritesIcon(forStatusImage: changeValueFavorite)
            cellDelegate?.onTouchFavorites(forValue: changeValueFavorite, forId: valueId)
        }
    }
    
    func setupCell(data: Products) {
        titleProduct.text = data.title.maxLength(length: 30).breakLine()
        priceProduct.text = data.price.currency()
        setupImageProduct(image: data.thumbnail)
        setFavoritesIcon(forStatusImage: data.isFavorite)
        isFavorite = data.isFavorite
        idCell = data.id
    }
    
    private func setupShadow() {
        self.layer.shadowColor = Colors.Shadow?.cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func setFavoritesIcon(forStatusImage status: Bool?) {
        if let value = status {
            value == true ? favoriteIcon.setImage(Icons.FavoriteAdded, for: .normal) : favoriteIcon.setImage(Icons.Favorite, for: .normal)
        }
    }
    
    private func setupImageProduct(image: String?) {
        guard let path = image else { return }
        productImg.sd_setImage(with: URL(string: path))
    }
    
}

