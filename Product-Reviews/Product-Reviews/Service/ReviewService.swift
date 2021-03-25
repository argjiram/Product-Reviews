//
//  ReviewService.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/25/21.
//

import Foundation

protocol ReviewServiceProtocol {
    func sendReview(parameters: Review, _ completion: @escaping ((Review?, Int, String?) -> Void))
}
class ReviewService: ReviewServiceProtocol {
    
    let httpClient:HttpClientProtocol

    init() {
        self.httpClient = HttpClient(baseUrl: Constants.BASE_URL_REVIEW, urlSession: URLSession.shared)
    }
    
    func sendReview(parameters: Review, _ completion: @escaping ((Review?, Int, String?) -> Void)) {
        httpClient.request(endpoint: "\(Constants.REVIEW)/\(parameters.productId)", params: parameters, httpMethod: .POST, returnType: Review.self) { (result, statusCode) in
            switch result {
            case .successful(let response):
                completion(response, statusCode, nil)
            case .failed(let error):
                completion(nil, statusCode, error.localizedDescription)
            }
        }
    }
}
