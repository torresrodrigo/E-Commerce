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
    
}
