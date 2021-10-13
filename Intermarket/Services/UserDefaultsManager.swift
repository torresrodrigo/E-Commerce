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
    
    //Login
    func setLoggedUser() {
        userDefaults.set(true, forKey: UserDefaultsKeys.LoggedUser)
    }
    
    func setLoginType(loginType: LoginType) {
        userDefaults.set(loginType.rawValue, forKey: UserDefaultsKeys.LoginType)
        print(loginType)
    }
    
    func getLoginType() -> LoginType? {
        var data: LoginType?
        if let LoginTypeRawValue = userDefaults.object(forKey: UserDefaultsKeys.LoginType) as? String {
            data = LoginType(rawValue: LoginTypeRawValue)
        }
        return data
    }
    
    //Favorites
    func setFavorites(favorites: [Products]?) {
        if let encodedData = try? JSONEncoder().encode(favorites) {
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
    
    //Cart
    func setProductInCart(dataProduct: DetailProduct) {
        let allProducts = getProductInCar()
        let newData = checkCart(id: dataProduct.id, dataProducts: allProducts, product: dataProduct)
        if let encodedData = try? JSONEncoder().encode(newData) {
            userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.ProductInCart)
        }
    }
    
    func setProductsInCart(totalProductsData: [DetailProduct]) {
        if let encodedData = try? JSONEncoder().encode(totalProductsData) {
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
    
    func checkCart(id: String, dataProducts: [DetailProduct], product: DetailProduct) -> [DetailProduct] {
        var allProductData = dataProducts
        if dataProducts.isEmpty || dataProducts.contains(where: {$0.id != id}) {
            allProductData.append(product)
        }
        else {
            print("This product is now in car")
        }
        return allProductData
    }
    
    
    //Image Profile
    func setImage(image: UIImage) {
        if let png = image.pngData() {
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
