//
//  ProductListViewController.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import UIKit
import Toast_Swift

class ProductListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let viewModel = ProductListViewModel(service: ProductService())
    
    var checkString: String = ""
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initViewModel()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !NetworkManager.isReachable() {
            self.view.makeToast(Constants.INTERNET_CONNECTION, duration: 1.5, position: .bottom)
        } else {
            viewModel.getProductList()
        }
        
    }

    func setupView(){
        searchBar.delegate = self
        let productCell = UINib(nibName: "ProductTableViewCell", bundle: nil)
        self.tableView.register(productCell, forCellReuseIdentifier: "ProductTableViewCell")
        let noDataView = UINib(nibName: "NoDataTableViewCell", bundle: nil)
        self.tableView.register(noDataView, forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 220
    }
    
    func setupSearchBar(){
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.clear
            searchBar.searchTextField.tintColor = .black
            searchBar.searchTextField.textColor = .black
        } else {
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .black
            textFieldInsideSearchBar?.tintColor = .black
            textFieldInsideSearchBar?.backgroundColor = .clear
        }
    }
    
    func initViewModel(){
        viewModel.successfulRequest = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.onErrorHandling = {
            DispatchQueue.main.async {
                self.view.makeToast(self.viewModel.message, duration: 1.0, position: .bottom)
            }
        }
    }
}


extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if viewModel.getNrOfSearchedProducts() == 0 {
                return 1
            }
            return viewModel.getNrOfSearchedProducts()
        }
        return viewModel.getNrOfProducts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell else  {
            return UITableViewCell()
        }
        if isSearching {
            if viewModel.getNrOfSearchedProducts() == 0 {
                guard let noDataCell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell else  {
                    return UITableViewCell()
                }
                return noDataCell
            }else {
                if let productModel = viewModel.getSearchedProduct(forRow: indexPath.row) {
                    cell.setupCellView(productModel: productModel)
                }
            }
        }else {
            if let productModel = viewModel.getProduct(forRow: indexPath.row) {
                cell.setupCellView(productModel: productModel)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !NetworkManager.isReachable() {
            self.view.makeToast(Constants.INTERNET_CONNECTION, duration: 1.5, position: .bottom)
        } else {
            if isSearching {
                if let productModel = viewModel.getSearchedProduct(forRow: indexPath.row) {
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
                        viewController.productID = productModel.id
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }else {
                if let productModel = viewModel.getProduct(forRow: indexPath.row) {
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
                        viewController.productID = productModel.id
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }

        }
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearSearchView()
        self.searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            isSearching = true
                self.viewModel.returnSearchedProduct(key: searchText)
                self.tableView.reloadData()
        } else if searchText == "" {
            clearSearchView()
        }
        checkString = searchBar.text ?? ""
    }
    
    func clearSearchView(){
        isSearching = false
        viewModel.clearSearchedArray()
        tableView.reloadData()
    }
}

