//
//  OnboardingCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 13/08/2021.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: OnboardingCollectionViewCell.self), bundle: nil)
    }
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var subtitleCell: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(forSlices slices: Slices) {
        titleCell.text = slices.title
        subtitleCell.text = slices.subtitle
        imgCell.image = slices.image
    }
    
    let slices1 = Slices(title: "Buscá", subtitle: "Explorá productos y elegí el mejor", image: Images.Slice1!)
    let slices2 = Slices(title: "Agregá al carrito", subtitle: "Ve la suma de dinero que gastarás", image: Images.Slice2!)
    let slices3 = Slices(title: "Es tuyo", subtitle: "Confirma la compra", image: Images.Slice3!)
}
