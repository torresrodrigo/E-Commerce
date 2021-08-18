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
    }
    
    func setupCell(forSlices slices: Slices) {
        titleCell.text = slices.title
        subtitleCell.text = slices.subtitle
        imgCell.image = slices.image
    }
}
