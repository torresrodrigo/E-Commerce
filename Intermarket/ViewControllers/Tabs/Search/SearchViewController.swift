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
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var suggestionTableView: UITableView!
    
    static let identifier = String(describing: SearchViewController.self)
    
    let favoritesViewController = FavoritesViewController()
    
    var products = [Products]()
    var suggestions = [Products]()
    var favorites = [Products]()
    var cellPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.sharedInstance.remove(key: UserDefaultsKeys.Favorites)
        UserDefaultsManager.sharedInstance.remove(key: UserDefaultsKeys.ProductInCart)
        setupUI()
        getValuesUserDefaults()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupCollectionView()
        hideKeyboard()
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
    
    private func totalEmptyUI() {
        imgSearch.isHidden = true
        searchLabel.isHidden = true
        getSearchTitle.isHidden = true
        getSearchSubtitle.isHidden = true
        productsCollectionViewCell.isHidden = true
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func getResultsSearch(forQuery query: String?) {
        guard let searchText = query else { return }
        NetworkService.shared.getProducts(query: searchText) { response in
            switch response {
            case .success(let response):
                self.products = self.setValuesOfFavorites(forProducts: response.results)
                self.suggestions = response.results
                DispatchQueue.main.async {
                    self.suggestionTableView.reloadData()
                    self.productsCollectionViewCell.reloadData()
                }
            case .failure(let error):
                print("Something is wrong. Error: \(error.localizedDescription)")
            }
        }
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            setSearchUI(isEmptyText: true)
            suggestionView.isHidden = true
            setupTableView()
        }
    }
    
    //Acelerated Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let count = searchBar.text?.count else { return }
        if count > 2 {
            suggestionAction()
            reloadData()
        }
        else {
            setSearchUI(isEmptyText: true)
            suggestionView.isHidden = true
            suggestionTableView.reloadData()
        }
    }
    
    private func suggestionAction() {
        self.suggestionView.isHidden = false
        self.totalEmptyUI()
        getResultsSearch(forQuery: searchBar.text?.remplaceTextInQuery())
    }
    
    //Perform search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarAction()
    }
    
    func searchBarAction() {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.remplaceTextInQuery() else { return }
        getResultsSearch(forQuery: searchText)
        setSearchUI(isEmptyText: false)
        suggestionView.isHidden = true
    }
    
    func reloadData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchReload), object: nil)
        self.perform(#selector(searchReload), with: nil, afterDelay: 4)
    }
    
    @objc func searchReload() {
        guard let searchText = searchBar.text?.remplaceTextInQuery() else { return }
        getResultsSearch(forQuery: searchText)
        suggestionView.isHidden = true
        setSearchUI(isEmptyText: false)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        suggestionTableView.register(SuggestionProductsTableViewCell.nib(), forCellReuseIdentifier: SuggestionProductsTableViewCell.identifier)
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionTableView.dequeueReusableCell(withIdentifier: SuggestionProductsTableViewCell.identifier, for: indexPath) as! SuggestionProductsTableViewCell
        cell.setupCell(forData: suggestions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchSuggestionCell))
        let cell = suggestionTableView.cellForRow(at: indexPath) as! SuggestionProductsTableViewCell
        cell.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchSuggestionCell() {
        searchBarAction()
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
        detailVC.delegate = self
        detailVC.productData = products[indexPath.row]
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
        guard let dataUserDefaults = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        favorites.append(contentsOf: dataUserDefaults)
    }
    
    func favoritesButtonTouch(forValue value: Bool, forId id: String) {
        guard let dataFavorites = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        var favoritesUserDefaults = dataFavorites
        if let i = products.firstIndex(where: {$0.id == id})  {
            if value == true {
                if favoritesUserDefaults.isEmpty || favoritesUserDefaults.contains(where: {$0.id != id }) {
                    products[i].isFavorite = value
                    productsCollectionViewCell.reloadData()
                    favorites.append(products[i])
                    favoritesUserDefaults.append(products[i])
                    UserDefaultsManager.sharedInstance.setFavorites(value: favoritesUserDefaults)
                }
            }
            else {
                products[i].isFavorite = value
                productsCollectionViewCell.reloadData()
                let newFavorites = favorites.filter {$0.id != id}
                favorites = newFavorites
                favoritesUserDefaults = newFavorites
                UserDefaultsManager.sharedInstance.setFavorites(value: favoritesUserDefaults)
            }
        }
    }
        
}

extension SearchViewController: DetailViewControllerDelegate {
    func updateFavorite(forId id: String, forValue value: Bool) {
        actionUpdateFavorites(forId: id, forValue: value)
    }
    
    func actionUpdateFavorites(forId id: String, forValue value: Bool) {
        if let index = products.firstIndex(where: {$0.id == id }) {
            if value == true {
                products[index].isFavorite = value
                productsCollectionViewCell.reloadData()
            }
            else {
                products[index].isFavorite = value
                productsCollectionViewCell.reloadData()
            }
        }
    }
    
}
