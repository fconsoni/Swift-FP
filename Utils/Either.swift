//
//  Either.swift
//  Previando
//
//  Created by Franco Consoni on 01/10/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation
import AutoEquatable

enum Either<T, U>: AutoEquatable {
    case left(T)
    case right(U)
 
    init(_ value: T) {
        self = .left(value)
    }
    
    init(_ value: U) {
        self = .right(value)
    }
    
    var left: T? {
        switch self {
        case let .left(left):
            return left
        case .right:
            return .none
        }
    }
    
    var right: U? {
        switch self {
        case .left:
            return .none
        case let .right(right):
            return right
        }
    }
}
