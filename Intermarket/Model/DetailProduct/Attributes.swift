//
//  Attributes.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 31/08/2021.
//

import Foundation

struct Attributes: Codable {
    let name: String
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case value = "value_name"
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
}
