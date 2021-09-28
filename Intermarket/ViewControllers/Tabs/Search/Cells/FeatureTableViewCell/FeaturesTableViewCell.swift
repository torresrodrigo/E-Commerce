//
//  FeaturesTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/09/2021.
//

import UIKit

class FeaturesTableViewCell: UITableViewCell {

    @IBOutlet weak var featureLabel: UILabel!
    
    static let identifier = String(describing: FeaturesTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: FeaturesTableViewCell.self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(featureName: String, featureValue: String?) {
        guard let value = featureValue else {
            featureLabel.text = "\(featureName): Not description"
            return }
        featureLabel.text = "\(featureName): \(value)"
    }
    
}
