//
//  SearchViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 17/08/2021.
//

import UIKit



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
    
    let userDefaults = UserDefaults.standard
    var products = [Products]()
    var favorites = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupCollectionView()
        getResultsSearch()
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
    
    //Perform search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getResultsSearch()
        setSearchUI()
    }
    
    private func setSearchUI() {
        imgSearch.isHidden = true
        searchLabel.isHidden = true
        getSearchTitle.isHidden = false
        getSearchSubtitle.isHidden = false
        productsCollectionViewCell.isHidden = false
    }
    
    //API CALL
    func getResultsSearch() {
        guard let textSearchBar = searchBar.text?.remplaceTextInQuery() else { return }
        let params = ["q" : textSearchBar]
        NetworkService.shared.getProducts(query: params) { response in
            switch response {
            case .success(let response):
                self.products = response.results
                DispatchQueue.main.async {
                    self.productsCollectionViewCell.reloadData()
                }
            case .failure(let error):
                print("Something is wrong. Error: \(error.localizedDescription)")
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 148, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
}

extension SearchViewController: ProductCellDelegate {
    
    func onTouchFavorites(forProduct product: Products)  {
        favoritesButtonTouch(forProduct: product)
    }
    
    func saveFavorites(forData data: [Products]) {
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: UserDefaultsKeys.Favorites)
        }
    }
    
    func favoritesButtonTouch(forProduct product: Products) {
        if product.isFavorite == true {
            favorites.append(product)
            print("Save Favorite")
            print("Count Favorites: \(favorites.count)")
            saveFavorites(forData: favorites)
        }
        else {
            let newFavorites = favorites.filter {$0.id != product.id}
            favorites = newFavorites
            print("Removed Favorite")
            print("Count Favorites: \(favorites.count)")
            saveFavorites(forData: favorites)
        }
    }
    
}
