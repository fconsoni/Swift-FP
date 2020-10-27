//
//  FPUtils.swift
//  Prebo
//
//  Created by Franco Consoni on 05/07/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

let π = Double.pi

//MARK:- generic functions
func identity<T>(_ any: T) -> T {
    return any
}

func appliedTo<T, U>(_ value: T) -> ((T) -> U) -> U {
    return { function in
        function(value)
    }
}

func nop() {}

func nop<T>(_ t: T) {}

func nop<T, U>(_ t: T, _ u: U) {}

func fst<A, B>(_ tuple: (A, B)) -> A {
    return tuple.0
}

func snd<A, B>(_ tuple: (A, B)) -> B {
    return tuple.1
}

func flip<A,B,C>(_ f: @escaping (A, B) -> C) -> (B, A) -> C {
    func mask(_ b: B, _ a: A) -> C {
        return f(a,b)
    }
    return mask
}

func flip<A,B,C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

//MARK:- currying functions
func curry<A,B,R>(_ f: @escaping (A, B) -> R) -> (A) -> (B) -> (R) {
    return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(_ f: @escaping (A, B, C) -> R) -> (A) -> (B) -> (C) -> (R) {
    return { a in curry{ b, c in f(a,b,c) } }
}

func curry<A,B,C,D,R>(_ f: @escaping (A, B, C, D) -> R) -> (A) -> (B) -> (C) -> (D) -> (R) {
    return { a in curry{ b, c, d in f(a,b,c,d) } }
}

func curry<A,B,C,D,E,R>(_ f: @escaping (A, B, C, D, E) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (R) {
    return { a in curry{ b, c, d, e in f(a,b,c,d,e) } }
}

func curry<A,B,C,D,E,F,R>(_ fx: @escaping (A, B, C, D, E, F) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (R) {
    return { a in curry{ b, c, d, e, f in fx(a,b,c,d,e,f) } }
}

//MARK:- logic functions
func equalTo<A: Equatable>(_ elem: A) -> (A) -> Bool {
    return { otherElem in elem == otherElem }
}

func isIn<T: Equatable>(_ elements: [T]) -> (T) -> Bool {
    return { element in
        elements.any(equalTo(element))
    }
}

func not(_ value: Bool) -> Bool {
    return !value
}

//MARK:- numeric functions
func max<A: Comparable>(_ a: A) -> (A) -> A {
    return { b in Swift.max(a, b) }
}

func min<A: Comparable>(_ a: A) -> (A) -> A {
    return { b in Swift.min(a, b) }
}

func isEven(_ number: Int) -> Bool {
    return number % 2 == 0
}

func between<A: Comparable>(_ a: A, and b: A) -> (A) -> A {
    return max(a) << min(b)
}

//MARK:- collection function
func length<A: Collection>(_ a: A) -> Int {
    return a.lazy.count
}

func all<A: Collection>(_ condition: @escaping (A.Element) -> Bool) -> (A) -> Bool {
    return { collection in collection.all(condition) }
}

func any<A: Collection>(_ condition: @escaping (A.Element) -> Bool) -> (A) -> Bool {
    return { collection in collection.any(condition) }
}

func map<A, B>(_ fx: @escaping (A) -> B) -> ([A]) -> [B] {
    return { list in list.lazy.map(fx) }
}

func filter<A>(_ condition: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { list in list.lazy.filter(condition) }
}

func sorted<A: Comparable, Element>(by keyPath: KeyPath<Element, A>) -> ([Element]) -> [Element] {
    return { array in array.sorted(by: keyPath) }
}

func first<A>(_ list: [A]) -> A? {
    return list.lazy.first
}

func replicate<A>(times: Int) -> (@autoclosure () -> A) -> [A] {
    return { value in Array(0..<times).map { _ in value() }}
}

//MARK:- logic functions
prefix operator >
prefix func > <A>(_ value: A) -> (A) -> Bool where A: Comparable {
    return { otherValue in otherValue > value }
}

prefix operator >!
prefix func >! <A>(_ value: A) -> ((A) -> Bool) where A: Comparable {
    return flip(>)(value)
}

prefix operator /
prefix func / <A>(_ num: A) -> (A) -> A where A: FloatingPoint {
    return { otherValue in otherValue / num }
}

//MARK:- composition function
precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator << : CompositionPrecedence
func << <T,U,V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { f(g($0)) }
}

func << <T,U,V>(_ f: @escaping (U) -> V, _ keyPath: KeyPath<T, U>) -> (T) -> V {
    return { f($0[keyPath: keyPath]) }
}

func << <T,U,V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> () -> (U)) -> (T) -> V {
    return { f(g($0)()) }
}
