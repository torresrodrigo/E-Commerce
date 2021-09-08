//
//  String+Extensions.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation

extension String {
    
    func remplaceTextInQuery() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
    
    func maxLength(length: Int) -> String {
           var str = self
           let nsString = str as NSString
           if nsString.length >= length {
               str = nsString.substring(with:
                   NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length)
               )
           }
           return  str
       }

    func formatPrice() -> String {
        let countChart = self.count
        var price = self
        switch countChart {
        case 4:
            let index = self.index(self.startIndex, offsetBy: 1)
            price.insert(".", at: index)
            return price
        case 5:
            let index = self.index(self.startIndex, offsetBy: 2)
            price.insert(".", at: index)
            return price
        case 6:
            let index = self.index(self.startIndex, offsetBy: 3)
            price.insert(".", at: index)
            return price
        default:
            return price
        }
    }
    
    func breakLine() -> String {
        var text = self
        if self.count > 16 {
            let index = self.index(self.startIndex, offsetBy: 15)
            text.insert("\n", at: index)
        }
        return text
    }
}
