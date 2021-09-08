//
//  LocalManager.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 27/08/2021.
//

import Foundation

final class FavoritesManager {
    
    static let sharedInstance = FavoritesManager()
    let userDefaults = UserDefaults.standard
    
    func set(key: String, value: [Products]?) {
        if let encodedData = try? JSONEncoder().encode(value) {
            print("Encoded data: \(encodedData)")
            userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.Favorites)
        }
    }
    
    func get(key: String) -> [Products]? {
        var data = [Products]()
        if let decodedData = userDefaults.object(forKey: key) as? Data {
            let decodedProduct = try? JSONDecoder().decode([Products].self, from: decodedData)
            guard let product = decodedProduct else { return nil }
            data = product
        }
        return data
    }
    
    func remove(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
