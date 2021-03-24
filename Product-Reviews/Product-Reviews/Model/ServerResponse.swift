//
//  ServerResponse.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation

struct ErrorMessage: Decodable {
    let message:String
}

class EmptyParams :Encodable {
}

class EmptyResponse :Decodable {
}
