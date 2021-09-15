//
//  LocalManager.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 27/08/2021.
//

import Foundation
import UIKit

final class UserDefaultsManager {
    
    static let sharedInstance = UserDefaultsManager()
    let userDefaults = UserDefaults.standard
    
    func setFavorites(value: [Products]?) {
        if let encodedData = try? JSONEncoder().encode(value) {
            userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.Favorites)
        }
    }
    
    func getFavorites() -> [Products]? {
        var data = [Products]()
        if let decodedData = userDefaults.object(forKey: UserDefaultsKeys.Favorites) as? Data {
            let decodedFavorites = try? JSONDecoder().decode([Products].self, from: decodedData)
            guard let favorites = decodedFavorites else { return nil }
            data = favorites
        }
        return data
    }
    
    func setProductInCart(value: DetailProduct) {
        let data = getProductInCar()
        let newData = checkCart(forId: value.id, forData: data, forValue: value)
        if let encodedData = try? JSONEncoder().encode(newData) {
            userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.ProductInCart)
        }
    }
    
    func setProductsInCart(forValue value: [DetailProduct]) {
        if let encodedData = try? JSONEncoder().encode(value) {
            userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.ProductInCart)
        }
    }
    
    func getProductInCar() -> [DetailProduct] {
        var data = [DetailProduct]()
        if let decodedData = userDefaults.object(forKey: UserDefaultsKeys.ProductInCart) as? Data {
            guard let decodedProduct = try? JSONDecoder().decode([DetailProduct].self, from: decodedData) else { return data }
            data = decodedProduct
        }
        return data
    }
    
    func remove(key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func checkCart(forId id: String, forData data: [DetailProduct], forValue value: DetailProduct) -> [DetailProduct] {
        var newData = data
        if data.isEmpty || data.contains(where: {$0.id != id}) {
            newData.append(value)
        }
        else {
            print("This product is now in car")
        }
        return newData
    }
    
    func setImage(value: UIImage) {
        if let png = value.pngData() {
            userDefaults.setValue(png, forKey: UserDefaultsKeys.ImgProfile)
        }
    }
    
    func getImage() -> UIImage? {
        var imageFinal: UIImage?
        if let imageData = userDefaults.object(forKey: UserDefaultsKeys.ImgProfile) as? Data, let image = UIImage(data: imageData) {
            imageFinal = image
        }
        return imageFinal
    }
}
