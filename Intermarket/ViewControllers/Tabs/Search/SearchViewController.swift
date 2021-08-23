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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
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
        changeColorTextField()
    }
    
    //Color of textField in SearchBar
    private func changeColorTextField() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(named: "White")
            textField.alpha = 1
        }
    }
    
    //Restrict only 50 characters
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 50
    }
    
    //Perform search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        executedSearch()
        imgSearch.isHidden = true
        searchLabel.text = "Busqueda realizada"
    }
    
    //API CALL
    func executedSearch() {
        print("Executed Search")
        guard let textSearchBar = searchBar.text?.remplaceTextInQuery() else { return }
        print("Text: \(textSearchBar)")
        let params = ["q" : textSearchBar]
        NetworkService.shared.getProducts(query: params) { response in
            switch response {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Something is wrong. Error: \(error.localizedDescription)")
            }
        }
    }
    
}
