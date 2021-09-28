//
//  ProductsCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import UIKit
import SDWebImage

protocol ProductCollectionViewCellDelegate {
    func onTouchFavorites(isFavorite: Bool, id: String)
}

extension ProductCollectionViewCellDelegate {
    func deleteFavorites(id: String){}
}

class ProductsCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ProductsCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsCollectionViewCell.self), bundle: nil)
    }
    
    var cellDelegate: ProductCollectionViewCellDelegate? = nil
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
    
    //CHECK
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let stateFavorite = isFavorite, let valueId = idCell {
            isFavorite = !stateFavorite
            setFavoritesIcon(isFavoriteIcon: !stateFavorite)
            cellDelegate?.onTouchFavorites(isFavorite: !stateFavorite, id: valueId)
        }
    }
    
    func setupCell(data: Products) {
        titleProduct.text = data.title.maxLength(length: 30).breakLine()
        priceProduct.text = data.price.currency()
        setupImageProduct(image: data.thumbnail)
        setFavoritesIcon(isFavoriteIcon: data.isFavorite)
        isFavorite = data.isFavorite
        idCell = data.id
    }
    
    //Shadow cell
    private func setupShadow() {
        self.layer.shadowColor = Colors.Shadow?.cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func setFavoritesIcon(isFavoriteIcon: Bool?) {
        if let favoriteIconState = isFavoriteIcon {
            favoriteIcon.setImage( favoriteIconState ? Icons.FavoriteAdded : Icons.Favorite , for: .normal )
        }
    }
    
    private func setupImageProduct(image: String?) {
        guard let path = image else { return }
        productImg.sd_setImage(with: URL(string: path))
    }
    
}

