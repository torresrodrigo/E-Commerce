//
//  FavoritesViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 19/08/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    static let identifier = String(describing: FavoritesViewController.self)
    var favorites = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
    }
    
    func getFavorites() {
        guard let data = FavoritesManager.sharedInstance.get(key: UserDefaultsKeys.Favorites) else { return }
        favorites = data
        print(favorites.count)
    }
    
}
