//
//  Pictures.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 31/08/2021.
//

import Foundation

struct Pictures: Codable {
    let url: String
    
    enum CodingsKeys: String, CodingKey {
        case url
    }
    
    init(decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingsKeys.self)
        url = try values.decode(String.self, forKey: .url)
    }
}
