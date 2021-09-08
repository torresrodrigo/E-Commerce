//
//  ProductsTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 06/09/2021.
//

import UIKit

protocol ProductsTableViewCellDelegate {
    func updatePrice()
}

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
    
    //Properties
    var delegate: ProductsTableViewCellDelegate?
    var totalQuantity = Int()
    var totalPrice = 0.0
    var price = Double()
    var quantity = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(forData data: DetailProduct) {
        guard let quantityAvailable = data.quantityAvaibable else { return }
        titleProduct.text = data.title
        priceProduct.text = data.price.currency()
        imgProduct.sd_setImage(with: URL(string: data.pictures[0].url))
        productQuantity.text = "\(quantity)"
        price = data.price
        totalQuantity = quantityAvailable
        totalPrice = totalPriceSum(forQuantity: quantity, forProductPrice: price)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        plusButtonAction()
        delegate?.updatePrice()
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        minusButtonActionn()
        delegate?.updatePrice()
    }
    
    private func plusButtonAction() {
        if quantity < totalQuantity {
            quantity = quantity + 1
            productQuantity.text = "\(quantity)"
        } else {
            quantity = totalQuantity
            productQuantity.text = "\(quantity)"
        }
        totalPrice = totalPriceSum(forQuantity: quantity, forProductPrice: price)
    }
    
    private func minusButtonActionn() {
        if quantity > 1 {
            quantity = quantity - 1
            productQuantity.text = "\(quantity)"
        } else {
            quantity = 1
            productQuantity.text = "\(quantity)"
        }
        totalPrice = totalPriceSum(forQuantity: quantity, forProductPrice: price)
    }
    
    func totalPriceSum(forQuantity quantity: Int, forProductPrice: Double) -> Double {
        let priceTotal = Double(quantity) * price
        return priceTotal
    }
    
}

