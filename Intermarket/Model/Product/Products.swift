//
//  Products.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation

struct Products: Codable {
    var id: String
    var title: String
    var price: Double
    var thumbnail: String?
    var isFavorite: Bool?
 
    enum CodingsKeys: String, CodingKey {
        case id
        case title
        case price
        case thumbnail
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingsKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        price = try values.decode(Double.self, forKey: .price)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }
}
