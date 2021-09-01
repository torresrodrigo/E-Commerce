//
//  BaseProducts.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import Foundation

struct BaseProducts: Codable {
    
    let results: [Products]

    enum CodingsKeys: String, CodingKey {
        case results
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingsKeys.self)
        results = try values.decode([Products].self, forKey: .results)
    }
}
