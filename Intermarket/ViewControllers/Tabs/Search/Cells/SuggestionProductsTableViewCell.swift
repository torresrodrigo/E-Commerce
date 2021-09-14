//
//  SuggestionProductsTableViewCell.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 10/09/2021.
//

import UIKit


class SuggestionProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestionLabel: UILabel!
    static let identifier = String(describing: SuggestionProductsTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: String(describing: SuggestionProductsTableViewCell.self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(forData data: Products) {
        suggestionLabel.text = data.title
    }
    
}
