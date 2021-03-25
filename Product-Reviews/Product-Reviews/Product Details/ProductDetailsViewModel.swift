//
//  ProductDetailsViewModel.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/25/21.
//

import Foundation

class ProductDetailsViewModel {
    
    let productService: ProductServiceProtocol
    let reviewService: ReviewServiceProtocol
    
    init(productService: ProductServiceProtocol, reviewService: ReviewServiceProtocol) {
        self.productService = productService
        self.reviewService = reviewService
    }
    
    var onErrorHandling: (()->())?
    var successfulRequest: (() ->())?
    var successfulRequestSubmitReview: (() ->())?
    var message: String = ""
    
    private var productDetails: ProductModel?
    private var reviews: [Review] = []
    
    func getNrOfReviews() -> Int {
        return reviews.count
    }
    
    func getReview(forRow: Int) -> Review? {
        return reviews[forRow]
    }
    
    
    func returnProductDetails() -> ProductModel? {
        return productDetails
    }
    
    func getProductDetails(parameteres: ProductDetailsRequestParameter){
        productService.getProductDetails(parameters: parameteres) { (response, statusCode, errorMsg) in
            if statusCode == 200 {
                if let productDetails = response {
                    self.productDetails = productDetails
                    self.reviews = productDetails.reviews
                }
                self.successfulRequest?()
            }else {
                self.message = errorMsg ?? Constants.SOMETHING_WENT_WRONG
                self.onErrorHandling?()
            }
        }
    }
    
    func submitReview(parameters: Review){
        reviewService.sendReview(parameters: parameters) { (response, statusCode, errorMsg) in
            if statusCode == 200 || statusCode == 201 {
                self.successfulRequestSubmitReview?()
            } else {
                self.message = errorMsg ?? Constants.SOMETHING_WENT_WRONG
                self.onErrorHandling?()
            }
        }
    }
}
