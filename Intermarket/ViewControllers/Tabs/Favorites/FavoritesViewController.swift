//
//  FavoritesViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 19/08/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    static let identifier = String(describing: FavoritesViewController.self)
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesEmpty: UIImageView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var favorites = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
        checkEmptyCart()
        favoritesCollectionView.reloadData()
    }
    
    private func checkEmptyCart() {
        if favorites.count > 0 {
            setupUI(isEmpty: false)
        }
        else {
            setupUI(isEmpty: true)
        }
    }
    
    func setupUI(isEmpty value: Bool) {
        if value {
            favoritesCollectionView.isHidden = true
            favoritesLabel.isHidden = false
            favoritesEmpty.isHidden = false
        }
        else {
            favoritesCollectionView.isHidden = false
            favoritesLabel.isHidden = true
            favoritesEmpty.isHidden = true
        }
    }
    
    func getFavorites() {
        guard let data = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        favorites = data
        print(favorites.count)
    }

}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupTableView() {
        favoritesCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.setupCell(data: favorites[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 148, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.productData = favorites[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension FavoritesViewController: DetailViewControllerDelegate {
    func updateFavorite(forId id: String, forValue value: Bool) {
        actionUpdateFavorites(forId: id, forValue: value)
    }
    
    func actionUpdateFavorites(forId id: String, forValue value: Bool) {
        if let index = favorites.firstIndex(where: {$0.id == id }) {
            if value == true {
                favorites[index].isFavorite = value
                favoritesCollectionView.reloadData()
            }
            else {
                favorites[index].isFavorite = value
                favoritesCollectionView.reloadData()
            }
        }
    }
}


