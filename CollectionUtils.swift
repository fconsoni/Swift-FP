//
//  CollectionUtils.swift
//  Previando
//
//  Created by Franco Consoni on 15/07/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

extension Collection {
    func all(_ condition: (Element) -> Bool) -> Bool {
        return self.lazy.allSatisfy(condition)
    }
    
    func any(_ predicate: (Element) -> Bool)  -> Bool {
        return self.lazy.filter(predicate).count > 0
    }
}

extension Array {
    func take(_ number: Int) -> [Element] {
        let index = Swift.min(number, self.count)
        return Array(self.prefix(through: index - 1))
    }
    
    func tail() -> [Element] {
        if self.isEmpty {
            return []
        } else {
            return Array(self.suffix(self.count - 1))
        }
    }
    
    func drop(_ number: Int) -> Array {
        return Array(self.dropLast(number))
    }
}

extension String {
    func lines() -> [String] {
        return separateBy("\n")
    }
    
    func words() -> [String] {
        return separateBy(" ")
    }
    
    private func separateBy(_ separator: String) -> [String] {
        return self.components(separatedBy: CharacterSet(charactersIn: separator))
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func take(_ number: Int) -> String {
        let index = Swift.min(number, self.count)
        return String(self.prefix(through: .init(encodedOffset: (index - 1))))
    }
    
    func tail() -> String {
        if self.isEmpty {
            return ""
        } else {
            return String(self.suffix(self.count - 1))
        }
    }
    
    func drop(_ number: Int) -> String {
        return String(self.dropLast(number))
    }
}

extension NSAttributedString {
    func drop(_ number: Int) -> NSAttributedString {
        return self.attributedSubstring(from: NSRange(location: 0, length: max(0)(self.string.count - number)))
    }
}

infix operator + : AdditionPrecedence
func +<A: NSAttributedString>(_ attributedString: A, _ otherAttributed: A) -> NSAttributedString {
    let a = NSMutableAttributedString(attributedString: attributedString)
    a.append(otherAttributed)
    
    return a
}


func +<A>(_ dictionary: Dictionary<A, Any>, _ otherDictionary: Dictionary<A, Any>) -> Dictionary<A, Any> {
    return dictionary.merging(otherDictionary, uniquingKeysWith: { v1, v2 in v1 })
}
