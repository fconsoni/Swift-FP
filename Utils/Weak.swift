//
//  Weak.swift
//  Previando
//
//  Created by Franco Consoni on 21/09/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

struct Weak<T> {
    private weak var object: AnyObject?
    
    init(_ object: T) {
        self.object = object as AnyObject
    }
    
    init(_ object: T?) {
        self.object = object.fold(nil, { $0 as AnyObject }) 
    }
    
    init(_ value: Any) {
        self.object = value as AnyObject
    }
    
    var value: T? {
        return object as? T
    }
    
    func `do`(_ function: Selector) -> () -> Void {
        return {
            if self.object?.responds(to: function) ?? false {
                _ = self.object?.perform(function)
            }
        }
    }
}
