//
//  Result.swift
//  Previando
//
//  Created by Franco Consoni on 18/10/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

public enum Result<T>: Equatable {
    case success(T)
    case failure(Error)
    
    init(_ f: @autoclosure () throws -> T) {
        self = Result(try? f())
    }
    
    init(_ error: Error) {
        self = .failure(error)
    }
    
    init(_ t: T?) {
        switch t {
        case .none: self = .failure(NSError())
        case .some(let some): self = .success(some)
        }
    }
    
    func get() throws -> T {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    func isSuccess() -> Bool {
        switch self {
        case .success(_):
            return true
        case _ :
            return false
        }
    }
    
    func map<U>(_ tx: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return Result<U>.success(tx(value))
        case .failure(let error):
            return Result<U>.failure(error)
        }
    }
    
    public func flatMap<U>(_ transform: (T) throws -> U) -> Result<U> {
        switch self {
        case .success(let value): return try Result<U>(transform(value))
        case .failure(let error): return .failure(error)
        }
    }
    
    public func flatMap<U>(_ fx: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value): return fx(value)
        case .failure(let error): return .failure(error)
        }
    }
    
    func getOrElse(_ defVal: T) -> T {
        switch self {
        case .success(let value): return value
        case .failure(_): return defVal
        }
    }
    
    func toOptional() -> Optional<T> {
        switch self {
        case .success(let value):
            return Optional(value)
        case .failure:
            return .none
        }
    }
    
    func fold<U>(_ ifError: U, _ tx : (T) -> U) -> U {
        return map(tx).getOrElse(ifError)
    }
    
    @discardableResult
    func onError(_ fx: (Error) -> Void) -> Result<T> {
        switch self {
        case .success:
            return self
        case .failure(let error):
            fx(error)
            return self
        }
    }
    
    @discardableResult
    func onError(_ fx: @escaping () -> Void) -> Result<T> {
        return self.onError(fx << nop)
    }
    
    @discardableResult
    func onSuccess(_ fx: (T) -> Void) -> Result<T> {
        switch self {
        case .success(let value):
            fx(value)
            return self
        case .failure:
            return self
        }
    }
    
    @discardableResult
    func onSuccess(_ fx: @escaping () -> Void) -> Result<T> {
        return self.onSuccess(fx << nop)
    }
}

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success): return true
    case (.failure, .failure): return true
    default: return false
    }
}

func map<T, U>(_ tx: @escaping (T) -> U) -> (Result<T>) -> Result<U> {
    return { result in
        switch result {
        case .success(let value):
            return Result<U>.success(tx(value))
        case .failure(let error):
            return Result<U>.failure(error)
        }
    }
}
