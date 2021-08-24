//
//  Products.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation

struct Products: Codable {
    let title: String
    let price: Double
    let thumbnail: String?
    var isFavorite: Bool?
    
    enum CodingsKeys: String, CodingKey {
        case title
        case price
        case thumbnail
        case isFavorite
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingsKeys.self)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Double.self, forKey: .price)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        isFavorite = try values.decodeIfPresent(Bool.self, forKey: .isFavorite)
    }
}
