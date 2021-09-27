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
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var suggestionTableView: UITableView!
    
    static let identifier = String(describing: SearchViewController.self)
    var products = [Products]()
    var suggestions = [Products]()
    var favorites = [Products]()
    
    let notificationFavorites = Notification.Name(rawValue: NotificationsKeys.Favorites)
    let notificationSearch = Notification.Name(rawValue: NotificationsKeys.Search)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupCollectionView()
        keyboardTapGesture()
        createObserver()
    }
    
    private func setSearchUI(for isEmptyText: Bool) {
        imgSearch.isHidden = !isEmptyText
        searchLabel.isHidden = !isEmptyText
        getSearchTitle.isHidden = isEmptyText
        getSearchSubtitle.isHidden = isEmptyText
        productsCollectionView.isHidden = isEmptyText
    }
    
    private func totalEmptyUI() {
        imgSearch.isHidden = true
        searchLabel.isHidden = true
        getSearchTitle.isHidden = true
        getSearchSubtitle.isHidden = true
        productsCollectionView.isHidden = true
    }
    
    //Keyboard Actions
    func keyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    //API call
    func getResultsSearch(for query: String?) {
        guard let searchText = query else { return }
        NetworkService.shared.getProducts(query: searchText) { response in
            switch response {
            case .success(let response):
                self.products = self.setValuesOfFavorites(with: response.results)
                self.suggestions = response.results
                DispatchQueue.main.async {
                    self.suggestionTableView.reloadData()
                    self.checkFavoritesUserDefaults()
                    self.productsCollectionView.reloadData()
                }
            case .failure(let error):
                print("Something is wrong. Error: \(error.localizedDescription)")
            }
        }
    }
        
    //Set all values false from API
    func setValuesOfFavorites(with products: [Products]) -> [Products] {
        var productData = products
        if products.isEmpty == false {
            for i in 0...products.count - 1 {
                let value = false
                productData[i].isFavorite = value
            }
        }
        return productData
    }
    
    //Put elements in elements get from API CALL
    func checkFavoritesUserDefaults() {
        guard let userDefaultsData = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        let favoritesUserDefaults = userDefaultsData
        favoritesUserDefaults.forEach({ data in
            if let index = products.firstIndex(where: {$0.id == data.id} ) {
                products[index].isFavorite = true
            }
        })
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
        searchBar.searchTextField.textColor = .black
    }
    
    //Restrict only 50 characters
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 50
    }
    
    //Show empty state when begin typing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        textDidBeginAction(for: searchBar)
    }
    
    func textDidBeginAction(for searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            setSearchUI(for: true)
            suggestionView.isHidden = true
            setupTableView()
        }
    }
    
    //Acelerated Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        aceleratedSearchAction(for: searchBar)
    }
    
    func aceleratedSearchAction(for searchBar: UISearchBar ) {
        guard let count = searchBar.text?.count else { return }
        (count > 2) ? showSuggestion() : hideSuggestion()
    }
    
    func showSuggestion() {
        suggestionAction()
        reloadData()
    }
    
    func hideSuggestion() {
        setSearchUI(for: true)
        suggestionView.isHidden = true
        suggestionTableView.reloadData()
    }
    
    // Action to perform timer to show products in CollectionView
    func reloadData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchReload), object: nil)
        self.perform(#selector(searchReload), with: nil, afterDelay: 4)
    }
    
    @objc func searchReload() {
        guard let searchText = searchBar.text?.remplaceTextInQuery() else { return }
        getResultsSearch(for: searchText)
        searchText.count > 2 ? showResults() : nil
    }
    
    func showResults() {
        suggestionView.isHidden = true
        setSearchUI(for: false)
    }
    
    private func suggestionAction() {
        self.suggestionView.isHidden = false
        self.totalEmptyUI()
        getResultsSearch(for: searchBar.text?.remplaceTextInQuery())
    }
    
    //Perform search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let isEmpty = searchBar.text?.isEmpty {
            isEmpty ? nil : searchBarAction()
        }
        
    }
    
    //SearchBar Touch Action
    func searchBarAction() {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
            guard let searchText = self.searchBar.text?.remplaceTextInQuery() else { return }
            self.getResultsSearch(for: searchText)
            self.setSearchUI(for: false)
            self.suggestionView.isHidden = true
        }
    }
    
}

//MARK: - SuggestionTableView
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

//MARK: - ProductsCollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        productsCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
        cell.setupCell(data: products[indexPath.row])
        cell.cellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        detailVC.hidesBottomBarWhenPushed = true
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

//MARK: - ProductsDelegate
extension SearchViewController: ProductCollectionViewCellDelegate {
    
    //Action delegate
    func onTouchFavorites(with value: Bool, id: String) {
        favoritesButtonAction(with: value, id: id)
    }
    
    //Action when touch Favorite icon
    func favoritesButtonAction(with value: Bool, id: String) {
        guard let dataFavorites = UserDefaultsManager.sharedInstance.getFavorites() else { return }
        changeValueFavorites(with: value, with: id, with: products, for: dataFavorites)
    }
    
    
    func changeValueFavorites(with value: Bool, with id: String, with products: [Products], for favoritesUserDefaults: [Products]) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            value ? validateFavoritesUserDefaults(for: index, with: value, for: favoritesUserDefaults, with: id) : removeFavorites(for: index, with: value, for: favoritesUserDefaults, with: id)
        }
    }
    
    func validateFavoritesUserDefaults(for index: Int, with value: Bool, for userDefaults: [Products], with id: String) {
        userDefaults.isEmpty || userDefaults.contains(where: {$0.id != id}) ? addFavorite(for: index, with: value,  for: userDefaults) : nil
    }
    
    func addFavorite(for index: Int, with value: Bool, for favoritesUserDefaults: [Products]) {
        var newFavoritesUserDefaults = favoritesUserDefaults
        updateCollectionView(with: index, with: value)
        newFavoritesUserDefaults.append(products[index])
        UserDefaultsManager.sharedInstance.setFavorites(value: newFavoritesUserDefaults)
    }
    
    func removeFavorites(for index: Int, with value: Bool, for favoritesUserDefaults: [Products], with id: String) {
        var newFavoritesUserDefaults = favoritesUserDefaults
        updateCollectionView(with: index, with: value)
        let newFavorites = newFavoritesUserDefaults.filter {$0.isFavorite == true && $0.id != id}
        newFavoritesUserDefaults = newFavorites
        UserDefaultsManager.sharedInstance.setFavorites(value: newFavoritesUserDefaults)
        productsCollectionView.reloadData()
    }
    
    func updateCollectionView(with index: Int, with value: Bool) {
        products[index].isFavorite = value
        productsCollectionView.reloadData()
    }
        
}

//MARK: - Notification and Observer
extension SearchViewController {
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector:#selector(SearchViewController.updateFavorites(notification:)) , name: notificationFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.updateFavorites(notification:)), name: notificationSearch, object: nil)
    }
    
    @objc func updateFavorites(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            if let id = dict["id"] as? String, let value = dict["value"] as? Bool {
                setFalseFavorites(forId: id, forValue: value)
                productsCollectionView.reloadData()
            }
        }
    }
    
    func setFalseFavorites(forId id: String, forValue value: Bool) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            products[index].isFavorite = value
        }
    }
    
}
