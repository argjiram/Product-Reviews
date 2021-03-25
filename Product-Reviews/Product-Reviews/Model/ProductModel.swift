//
//  ProductModel.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation

struct ProductModel: Codable {
    let currency: String
    let price: Int
    let id: String
    let name: String
    let description: String
    let imgUrl: String
    let reviews: [Review]
}

struct Review: Codable {
    let productId: String
    let locale: String
    let rating: Int
    let text: String
}

struct ProductDetailsRequestParameter: Codable {
    let id: String
}

enum Rating: Int {
    case one
    case two
    case three
    case four
    case five
}
