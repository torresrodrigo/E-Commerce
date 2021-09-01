//
//  SearchViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit

protocol SearchViewControllerDelegate {
    func updateCell(forProduct productData: Products)
}

class SearchViewController: UIViewController {

    @IBOutlet weak var interTitle: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var getSearchTitle: UILabel!
    @IBOutlet weak var getSearchSubtitle: UILabel!
    @IBOutlet weak var productsCollectionViewCell: UICollectionView!
    
    static let identifier = String(describing: SearchViewController.self)
    
    let favoritesViewController = FavoritesViewController()
    
    var products = [Products]()
    var favorites = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getValuesUserDefaults()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupCollectionView()
    }
    
}

//MARK: -Search Bar
extension SearchViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        searchBar.delegate = self
        setupUISearchBar()
    }
    
    private func setupUISearchBar() { 
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
    }
    
    //Restrict only 50 characters
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 50
    }
    
    //Acelerated Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            setSearchUI(isEmptyText: true)
        }
        else if searchBar.text?.isEmpty == false {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchReload), object: nil)
            self.perform(#selector(searchReload), with: nil, afterDelay: 1.5)
            setSearchUI(isEmptyText: false)
        }
    }
    
    //Perform search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.remplaceTextInQuery() else { return }
        getResultsSearch(forQuery: searchText)
        setSearchUI(isEmptyText: false)
    }
    
    private func setSearchUI(isEmptyText value: Bool) {
        if value == false {
            imgSearch.isHidden = true
            searchLabel.isHidden = true
            getSearchTitle.isHidden = false
            getSearchSubtitle.isHidden = false
            productsCollectionViewCell.isHidden = false
        } else {
            imgSearch.isHidden = false
            searchLabel.isHidden = false
            getSearchTitle.isHidden = true
            getSearchSubtitle.isHidden = true
            productsCollectionViewCell.isHidden = true
        }
    }
    
    //API CALL
    func getResultsSearch(forQuery query: String?) {
        let params = ["q" : query]
        NetworkService.shared.getProducts(query: params) { response in
            switch response {
            case .success(let response):
                self.products = self.setValuesOfFavorites(forProducts: response.results)
                DispatchQueue.main.async {
                    self.productsCollectionViewCell.reloadData()
                }
            case .failure(let error):
                print("Something is wrong. Error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func searchReload() {
        guard let searchText = searchBar.text?.remplaceTextInQuery() else { return }
        getResultsSearch(forQuery: searchText)
        searchBar.resignFirstResponder()
    }
    
    func setValuesOfFavorites(forProducts products: [Products]) -> [Products] {
        var productData = products
        if products.isEmpty == false {
            for i in 0...products.count - 1 {
                let value = false
                productData[i].isFavorite = value
            }
        }
        return productData
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        productsCollectionViewCell.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productsCollectionViewCell.delegate = self
        productsCollectionViewCell.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionViewCell.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.setupCell(data: products[indexPath.row])
        cell.cellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.productID = products[indexPath.row].id
        detailVC.productPriceValue = products[indexPath.row].price.currency()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 148, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
}

extension SearchViewController: ProductCellDelegate {
    
    func onTouchFavorites(forValue value: Bool, forId id: String) {
        favoritesButtonTouch(forValue: value, forId: id)
    }
    
    func getValuesUserDefaults() {
        guard let dataUserDefaults = FavoritesManager.sharedInstance.get(key: UserDefaultsKeys.Favorites) else { return }
        favorites.append(contentsOf: dataUserDefaults)
    }
    
    func favoritesButtonTouch(forValue value: Bool, forId id: String) {
        if let i = products.firstIndex(where: {$0.id == id})  {
            if value == true {
                if favorites.isEmpty || favorites.contains(where: {$0.id != id }) {
                    products[i].isFavorite = value
                    productsCollectionViewCell.reloadData()
                    favorites.append(products[i])
                    FavoritesManager.sharedInstance.set(key: UserDefaultsKeys.Favorites, value: favorites)
                }
            }
            else {
                products[i].isFavorite = value
                productsCollectionViewCell.reloadData()
                let newFavorites = favorites.filter {$0.id != id}
                favorites = newFavorites
                FavoritesManager.sharedInstance.set(key: UserDefaultsKeys.Favorites, value: favorites)
            }
        }
    }
        
}
