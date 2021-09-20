//
//  ImgDetailCollectionViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 02/09/2021.
//

import UIKit

class ImgDetailCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ImgDetailCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: ImgDetailCollectionViewCell.self), bundle: nil)
    }
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imgCellProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codeO
    }
    
    func setupCell(forImage url: String?, forCount count: String) {
        guard let path = url else { return }
        imgCellProduct.sd_setImage(with: URL(string: path))
        countLabel.text = count
    }
    
}
