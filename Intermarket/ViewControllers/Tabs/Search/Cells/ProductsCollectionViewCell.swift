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
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupCell(data: Products) {
        titleProduct.text = data.title.maxLength(length: 30).breakLine()
        priceProduct.text = data.price.currency()
        setupImage(image: data.thumbnail)
    }
    
    private func setupImage(image: String?) {
        guard let path = image else { return }
        let url = path
        print("Url: \(url)")
        productImg.sd_setImage(with: URL(string: url))
    }
    
    private func setupShadow() {
        self.layer.shadowColor = Colors.Shadow?.cgColor
        self.layer.shadowOpacity = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
}
