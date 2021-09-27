//
//  FavoritesViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 19/08/2021.
//

import UIKit

protocol FavoritesViewControllerDelegate {
    func updateFavorites(forId id: String, forValue value: Bool)
}

class FavoritesViewController: UIViewController {
    
    static let identifier = String(describing: FavoritesViewController.self)
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesEmpty: UIImageView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var favorites = [Products]()
    var delegate: FavoritesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
        checkEmptyCart()
        favoritesCollectionView.reloadData()
    }
    
    //Validation to check if has products
    private func checkEmptyCart() {
        favorites.count > 0 ? setupUI(isEmpty: false) : setupUI(isEmpty: true)
    }
    
    func setupUI(isEmpty value: Bool) {
        favoritesCollectionView.isHidden = value ? true : false
        favoritesLabel.isHidden = value ? false : true
        favoritesEmpty.isHidden = value ? false : true
    }
    
    //Get data from UserDefaults
    func getFavorites() {
        guard let data = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        favorites = data
    }

}

//MARK: - FavoritesCollectionView
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
        cell.cellDelegate = self
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

//MARK: - ProductCellDelegate
extension FavoritesViewController: ProductCollectionViewCellDelegate {
    
    //Abstraer
    func onTouchFavorites(with valueCell: Bool, id: String) {
        if let index = favorites.firstIndex(where: {$0.id == id}) {
            valueCell ? nil : removeCell(with: id, value: valueCell, index: index)
        }
    }
    
    func removeCell(with id: String, value: Bool, index: Int) {
        favorites[index].isFavorite = value
        changeFavorites(with: id, valueCell: value)
        updateCollectionView()
        checkEmptyCart()
    }
    
    func changeFavorites(with id: String, valueCell: Bool) {
        let dict: [String : Any] = ["id" : id, "value" : valueCell]
        let notification = Notification.Name(rawValue: NotificationsKeys.Favorites)
        NotificationCenter.default.post(name: notification, object: dict)
    }
    
    func updateCollectionView() {
        let newFavorites = favorites.filter({$0.isFavorite == true})
        favorites = newFavorites
        UserDefaultsManager.sharedInstance.setFavorites(value: favorites)
        favoritesCollectionView.reloadData()
    }
    
}

