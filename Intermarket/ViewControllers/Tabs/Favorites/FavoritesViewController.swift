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
    @IBOutlet weak var scrollView: UIScrollView!
    var favorites = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
        self.perform(#selector(showUI),with: nil, afterDelay: 0.5)
        checkEmptyCart()
        favoritesCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scrollView.isHidden = true
    }
    
    @objc private func showUI() {
        UIView.transition(with: scrollView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.scrollView.isHidden = false })
        
    }
    
    //Validation to check if has products
    private func checkEmptyCart() {
        favorites.count > 0 ? setupUI(isEmpty: false) : setupUI(isEmpty: true)
    }
    
    func setupUI(isEmpty: Bool) {
        favoritesCollectionView.isHidden = isEmpty
        favoritesLabel.isHidden = !isEmpty
        favoritesEmpty.isHidden = !isEmpty
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
    func onTouchFavorites(isFavorite: Bool, id: String) {
        if let index = favorites.firstIndex(where: {$0.id == id}) {
            if !isFavorite {
                removeCell(id: id, isFavorites: isFavorite, index: index)
            }
        }
    }
    
    func removeCell(id: String, isFavorites: Bool, index: Int) {
        favorites[index].isFavorite = isFavorites
        changeFavorites(id: id, isFavorites: isFavorites)
        updateCollectionView()
        checkEmptyCart()
    }
    
    func changeFavorites(id: String, isFavorites: Bool) {
        let dict: [String : Any] = ["id" : id, "value" : isFavorites]
        let notification = Notification.Name(rawValue: NotificationsKeys.Favorites)
        NotificationCenter.default.post(name: notification, object: dict)
    }
    
    func updateCollectionView() {
        let newFavorites = favorites.filter({$0.isFavorite == true})
        favorites = newFavorites
        UserDefaultsManager.sharedInstance.setFavorites(favorites: favorites)
        favoritesCollectionView.reloadData()
    }
    
}

