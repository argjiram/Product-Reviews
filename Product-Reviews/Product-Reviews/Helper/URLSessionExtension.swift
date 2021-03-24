//
//  URLSessionExtension.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        return ((dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol)
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
