//
//  Network.swift
//  Previando
//
//  Created by Franco Consoni on 14/02/2020.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkError: Swift.Error {
    case invalidURL
    case noData
}

public protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

public struct URLSessionNetworkDispatcher: NetworkDispatcher {
    public static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    public func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: request.path) else {
            onError(NetworkError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let params = request.params {
            if request.method == .get {
                urlRequest = Result(try URLEncoding.default.encode(urlRequest, with: params)).getOrElse(urlRequest)
            } else {
                urlRequest.httpBody = Json(params).description.data(using: .utf8)!
            }
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            if let data = data {
                onSuccess(data)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                onError(NetworkError.noData)
                return
            }
            
        }.resume()
    }
}

//TODO: hacer propio encoder para dejar de depender de alamofire
//fileprivate func encodedQueryParams(from params: [String: Any?]) -> String {
//    let encodedParams = params.mapValues{ $0 ?? "" }.map{ (k, v) in "\(k)=\(v)" }.joined(separator: "&")
//
//    return "?" + encodedParams.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed).getOrElse("")
//}
