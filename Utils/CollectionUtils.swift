//
//  CollectionUtils.swift
//  Previando
//
//  Created by Franco Consoni on 15/07/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

extension Sequence {
    func map<T>(_ fx: (Element) -> () -> T) -> [T] {
        return lazy.map(fx).map{ $0() }
    }
}

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return lazy.map{ $0[keyPath: keyPath] }
    }
    
    func flatMap<T>(_ keyPath: KeyPath<Element, [T]>) -> [T] {
        return flatMap{ $0[keyPath: keyPath] }
    }
    
    func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return lazy.filter{ $0[keyPath: keyPath] }//map{ $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    func sortedReversed<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return self.sorted(by: keyPath).reversed()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func all(_ condition: (Element) -> Bool) -> Bool {
        return self.lazy.allSatisfy(condition)
    }
    
    func any(_ predicate: (Element) -> Bool)  -> Bool {
        return self.filter(predicate).count > 0
    }
}

extension Collection where Element: AdditiveArithmetic {
    func sum() -> Element {
        return self.lazy.reduce(.zero, +)
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
    
    func appending(_ element: Element) -> [Element] {
        var copy = self
        copy.append(element)
        
        return copy
    }
    
    func flatten<T>() -> [T] where Element == T? {
        return self.compactMap(identity)
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
        return String(self.prefix(index))
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


func +<A>(_ dictionary: [A: Any], _ otherDictionary: [A: Any]) -> [A: Any] {
    return dictionary.merging(otherDictionary, uniquingKeysWith: { v1, v2 in v1 })
}

infix operator ++ : AdditionPrecedence
func ++<A>(_ array: [A], _ element: A) -> [A] {
    return array.appending(element)
}
