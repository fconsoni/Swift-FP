//
//  RequestType.swift
//  Previando
//
//  Created by Fernando Romiti on 14/02/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public struct RequestData {
    public let path: String
    public let method: HTTPMethod
    public let params: [String: Any]?
    public let headers: [String: String]?
    
    public init(path: String, method: HTTPMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
    }
}

public protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData { get }
}

public extension RequestType {
    func execute(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance, onSuccess: @escaping (ResponseType) -> Void, onError: @escaping (Error) -> Void) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        onError(error)
                    }
                }
        },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
        }
        )
    }
}

struct RequestHeaders {
    func getHeaders() -> [String : String] {
        if ConnectState.shared.accessToken().isEmpty {
            return self.getContentTypeHeader()
        } else {
            return ["Authorization" : "Bearer \(ConnectState.shared.accessToken())", "Content-Type" : "application/json"]
        }
    }
    
    func getContentTypeHeader() -> [String: String] {
        return ["Content-Type" : "application/json"]
    }
}
