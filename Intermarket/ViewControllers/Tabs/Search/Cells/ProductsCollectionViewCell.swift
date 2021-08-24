//
//  ProductsCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ProductsCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsCollectionViewCell.self), bundle: nil)
    }
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    var imgStatus = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        setupShadow()
    }
    
    func setupCell(data: Products) {
        titleProduct.text = data.title.maxLength(length: 30).breakLine()
        priceProduct.text = data.price.currency()
        setupImage(image: data.thumbnail)
        checkFavorites()
    }
    
    func checkFavorites() {
        imgStatus ? favoriteIcon.setImage(Icons.FavoriteAdded, for: .normal) : favoriteIcon.setImage(Icons.Favorite, for: .normal)
    }
    
    private func setupImage(image: String?) {
        guard let path = image else { return }
        productImg.sd_setImage(with: URL(string: path))
    }
    
    private func setupShadow() {
        self.layer.shadowColor = Colors.Shadow?.cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        changeIconFavorites()
    }
    
    func changeIconFavorites() {
        if favoriteIcon.currentImage == Icons.Favorite {
            favoriteIcon.setImage(Icons.FavoriteAdded, for: .normal)
        } else {
            favoriteIcon.setImage(Icons.Favorite, for: .normal)
        }
    }
    
}
