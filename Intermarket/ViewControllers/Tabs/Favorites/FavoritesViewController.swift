//
//  FavoritesViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 19/08/2021.
//

import UIKit

class FavoritesViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    static let identifier = String(describing: FavoritesViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
    }
    
    func getFavorites() {
        var favorites = [Products]()
        if let decodedData = userDefaults.object(forKey: UserDefaultsKeys.Favorites) as? Data {
            let decodedProduct = try? JSONDecoder().decode([Products].self, from: decodedData)
            guard let products = decodedProduct else {return}
            favorites.append(contentsOf: products)
            printFavorites(forProduct: favorites)
        }
    }
    
    func printFavorites(forProduct products: [Products]?) {
        guard let product = products else { return }
        if product.isEmpty == false {
            for i in 0..<product.count {
                print("ID \(i) : \(product[i].id)")
                print("Title \(i) : \(product[i].title)")
                print("Price \(i) : \(product[i].price)")
                print("Favorite\(i) : \(product[i].isFavorite)")
            }
        }
        print("Products count: \(product.count)")
    }
    
    
}
