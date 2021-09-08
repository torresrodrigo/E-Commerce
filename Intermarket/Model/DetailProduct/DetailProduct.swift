//
//  DetailProduct.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 31/08/2021.
//

import Foundation

struct DetailProduct: Codable {
    let id: String
    let title: String
    let price: Double
    let subtitle: String?
    let quantityAvaibable: Int?
    var quantity: Int?
    let pictures: [Pictures]
    let attributes: [Attributes]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case subtitle
        case pictures
        case quantityAvaibable = "available_quantity"
        case quantity
        case attributes
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        price = try values.decode(Double.self, forKey: .price)
        quantityAvaibable = try values.decodeIfPresent(Int.self, forKey: .quantityAvaibable)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        pictures = try values.decode([Pictures].self, forKey: .pictures)
        attributes = try values.decodeIfPresent([Attributes].self, forKey: .attributes)
    }
}
