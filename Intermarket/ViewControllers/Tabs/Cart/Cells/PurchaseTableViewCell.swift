//
//  PurchaseTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 06/09/2021.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    static let identifier = String(describing: PurchaseTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: PurchaseTableViewCell.self), bundle: nil)
    }
    
    //UI Components
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(forData data: DetailProduct) {
        guard let quantity = data.quantity else { return }
        productImg.sd_setImage(with: URL(string: data.pictures[0].url))
        productTitle.text = data.title
        productPrice.text = data.price.currency()
        productQuantity.text = "\(quantity)"
    }
    
}
