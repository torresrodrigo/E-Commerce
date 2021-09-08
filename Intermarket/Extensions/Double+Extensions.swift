//
//  Double+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation

extension Double {
    
    func transformInText() -> String {
        return String(describing: self)
    }
    
    func removeZero() -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 0
        formatter.maximumIntegerDigits = 16
        let numberFormatted = String(formatter.string(from: NSNumber(value: self)) ?? "")
        return numberFormatted
    }
    
    func currency() -> String {
        let formatter = NumberFormatter()
        var price = String()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        
        if let priceString = formatter.string(from: NSNumber(value: self)) {
            price = priceString
        }
        
        return price
    }
    
}
