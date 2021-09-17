//
//  ProductsTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 06/09/2021.
//

import UIKit

protocol ProductsTableViewCellDelegate {
    func updateCell(forId id: String, forQuantity newQuantity: Int)
    func deleteProduct(forId id: String)
}

class ProductsTableViewCell: UITableViewCell {

    //MARK: - Setup
    static let identifier = String(describing: ProductsTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ProductsTableViewCell.self), bundle: nil)
    }
    
    //MARK: - Components UI
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    //MARK: - Components UI StackView
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    
    //Properties
    var delegate: ProductsTableViewCellDelegate?
    var id = String()
    var totalQuantity = Int()
    var price = Double()
    var quantity = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(forData data: DetailProduct) {
        guard let quantityAvailable = data.quantityAvaibable , let quantitySelected = data.quantity  else { return }
        titleProduct.text = data.title
        priceProduct.text = data.price.currency()
        imgProduct.sd_setImage(with: URL(string: data.pictures[0].url))
        productQuantity.text = "\(quantitySelected)"
        quantity = quantitySelected
        id = data.id
        price = data.price
        totalQuantity = quantityAvailable
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any ){
        delegate?.deleteProduct(forId: id)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        plusButtonAction()
        delegate?.updateCell(forId: id, forQuantity : quantity)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        minusButtonActionn()
        delegate?.updateCell(forId: id, forQuantity: quantity)
    }
    
    //Action when add
    private func plusButtonAction() {
        if quantity < totalQuantity {
            quantity = quantity + 1
            productQuantity.text = "\(quantity)"
        } else {
            quantity = totalQuantity
            productQuantity.text = "\(quantity)"
        }
    }
    
    //Action when minus
    private func minusButtonActionn() {
        if quantity > 1 {
            quantity = quantity - 1
            productQuantity.text = "\(quantity)"
        } else {
            quantity = 0
            productQuantity.text = "\(quantity)"
        }
    }
    
}

