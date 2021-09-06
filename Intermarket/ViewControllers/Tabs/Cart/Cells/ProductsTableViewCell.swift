//
//  ProductsTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 06/09/2021.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    //MARK: - Setup
    static let identifier = String(describing: ProductsTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsTableViewCell.self), bundle: nil)
    }
    
    //MARK: - Components UI
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    //MARK: - Components UI StackView
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(forData data: DetailProduct) {
        titleProduct.text = data.title
        priceProduct.text = data.price.currency()
        imgProduct.sd_setImage(with: URL(string: data.pictures[0].url))
    }
    
}

