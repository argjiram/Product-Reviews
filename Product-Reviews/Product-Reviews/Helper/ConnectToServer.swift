//
//  ConnectToServer.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import Foundation

//MARK: -HTTP Methods
enum HttpMethod: String{
    case GET    = "GET"
    case DELETE = "DELETE"
    case POST   = "POST"
    case PUT    = "PUT"
}

//MARK: -Custom Error
enum HttpError: Error {
    case JSON
    case PARSING
    case UNKNOWN
    case SERVER(Data)
    case URL
    case NODATA
    case MSG(msg: String)
}

//MARK: - Custom Request result

enum Result<T>{
    case failed(HttpError)
    case successful(T)
}

protocol HttpClientProtocol{
    func request<T:Encodable, G:Decodable>(endpoint: String,
                                           params:T,
                                           httpMethod:HttpMethod,
                                           returnType:G.Type,
                                           onCompletion: @escaping (Result<G>, _ statusCode: Int) -> Void)
}


final class HttpClient: HttpClientProtocol {
    
    private let baseUrl: String
    private let urlSession: URLSessionProtocol
    convenience init() {
        self.init(baseUrl: Constants.BASE_URL, urlSession: URLSession.shared)
    }
    
    init(baseUrl: String, urlSession: URLSessionProtocol) {
        
        self.baseUrl    = baseUrl
        self.urlSession = urlSession
    }
    
    //MARK: - API Request calling
    func request<T:Encodable, G:Decodable>(endpoint: String,
                                           params:T,
                                           httpMethod:HttpMethod,
                                           returnType:G.Type,
                                           onCompletion: @escaping (Result<G>, _ statusCode: Int) -> Void) {
        
        createRequest(endpoint: endpoint, params: params, httpMethod: httpMethod) {
            result in
            switch result{
            case .successful(let request):
                let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) -> Void in
                    
                    guard let httpResponse = urlResponse as? HTTPURLResponse else {
                        onCompletion(.failed(.NODATA), 400)
                        return
                    }
                    
                    let statusCode = httpResponse.statusCode
                    
                    
                    guard let responseData = data else {
                        onCompletion(.failed(.NODATA), statusCode)
                        return
                    }
                    guard error == nil else {
                        onCompletion(.failed(.UNKNOWN), statusCode)
                        return
                    }
                    do {
                        if statusCode == 200 {
                            let returnValue = try JSONDecoder().decode(returnType, from: responseData)
                            print(returnValue)
                            onCompletion(.successful(returnValue), statusCode)
                        } else {
                            let returnValue = try JSONDecoder().decode(ErrorMessage.self, from: responseData)
                            print(returnValue)
                            onCompletion(.failed(.MSG(msg: returnValue.message)), statusCode)
                        }
                        
                    }
                    catch (let error){
                        print(error)
                        do {
                            let returnValue = try JSONDecoder().decode(ErrorMessage.self, from: responseData)
                            print(responseData)
                            onCompletion(.failed(.MSG(msg: returnValue.message)), statusCode)
                        }
                        catch (let error){
                            print(error)
                            onCompletion(.failed(.SERVER(responseData)), statusCode)
                        }
                    }
                }
                task.resume()
            case .failed:
                onCompletion(.failed(.URL), 0)
            }
        }
    }
    
    //MARK: - Request creation
    func createRequest<T:Encodable>(endpoint: String,
                                    params:T,
                                    httpMethod:HttpMethod,
                                    onCompletion: @escaping (Result<URLRequest>) -> Void){
        guard let url = URL(string: baseUrl + endpoint) else {
            onCompletion(.failed(.URL))
            return
        }
        var request:URLRequest
        
        if httpMethod == .GET {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let mirrorObject = Mirror(reflecting: params)
            var shouldClear = true
            
            for (_, attr) in mirrorObject.children.enumerated() {
                if shouldClear {
                    components?.queryItems = [URLQueryItem]()
                    shouldClear = false
                }
                if let property_name = attr.label {
                    components?.queryItems?.append(URLQueryItem(name: property_name, value: "\(attr.value)"))
                }
            }
            request = URLRequest(url: components!.url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            URLCache.shared.removeCachedResponse(for: request)
        }
        else {
            request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            URLCache.shared.removeCachedResponse(for: request)
            do {
                let parametersData = try JSONEncoder().encode(params)
                request.httpBody = parametersData
            }
            catch {
                print("ERROR ADDING PARAMS TO REQUEST: \(error.localizedDescription)")
            }
        }
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        onCompletion(.successful(request))
    }
}

