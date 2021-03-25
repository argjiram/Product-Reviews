//
//  ProductService.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation

protocol ProductServiceProtocol {
    func getListOfProducts(_ completion: @escaping (([ProductModel]?, Int, String?) -> Void))
    func getProductDetails(parameters: ProductDetailsRequestParameter, _ completion: @escaping ((ProductModel?, Int, String?) -> Void))
}

class ProductService: ProductServiceProtocol {
    let httpClient:HttpClientProtocol

    init() {
        self.httpClient = HttpClient(baseUrl: Constants.BASE_URL, urlSession: URLSession.shared)
    }
    
    func getListOfProducts(_ completion: @escaping (([ProductModel]?, Int, String?) -> Void)) {
        httpClient.request(endpoint: Constants.PRODUCTS, params: EmptyParams(), httpMethod: .GET, returnType: [ProductModel].self) { (result, statusCode) in
            switch result {
            case .successful(let response):
                completion(response, statusCode, nil)
            case .failed(let error):
                completion(nil, statusCode, error.localizedDescription)
            }
        }
    }
    
    func getProductDetails(parameters: ProductDetailsRequestParameter, _ completion: @escaping ((ProductModel?, Int, String?) -> Void)) {
        httpClient.request(endpoint: "\(Constants.PRODUCTS)/\(parameters.id)", params: EmptyParams(), httpMethod: .GET, returnType: ProductModel.self) { (result, statusCode) in
            switch result {
            case .successful(let response):
                completion(response, statusCode, nil)
            case .failed(let error):
                completion(nil, statusCode, error.localizedDescription)
            }
        }
    }
    
}
