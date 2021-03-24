//
//  ProductListViewModel.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation


class ProductListViewModel {
    
    let service: ProductServiceProtocol
       
    init(service: ProductServiceProtocol) {
        self.service = service
    }
    
    var onErrorHandling: (()->())?
    var successfulRequest: (() ->())?
    var message: String = ""
    
    private var products: [ProductModel] = []
    private var searchedProducts: [ProductModel] = []
    
    func getNrOfProducts() -> Int {
        return products.count
    }
    
    func getProduct(forRow: Int) -> ProductModel? {
        return products[forRow]
    }
    
    func getNrOfSearchedProducts() -> Int {
        return searchedProducts.count
    }
    
    func getSearchedProduct(forRow: Int) -> ProductModel? {
        return searchedProducts[forRow]
    }
    
    func clearSearchedArray(){
        searchedProducts.removeAll()
    }
    
    func returnSearchedProduct(key: String){
        searchedProducts = products.filter({ (product : ProductModel) -> Bool in
            return product.name.lowercased().contains(key.lowercased()) || product.description.lowercased().contains(key.lowercased())
        })
    }
    
    func getProductList(){
        service.getListOfProducts { (response, statusCode, errorMsg) in
            if statusCode == 200 {
                if let products = response {
                    self.products = products
                }
                self.successfulRequest?()
            }else {
                self.message = errorMsg ?? Constants.SOMETHING_WENT_WRONG
                self.onErrorHandling?()
            }
        }
    }
}
