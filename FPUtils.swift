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

func nop() {}

func nop<T>(_ t: T) {}

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

//MARK:- currying functions
func curry<A,B,R>(_ f: @escaping (A, B) -> R) -> (A) -> (B) -> (R) {
    return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(_ f: @escaping (A, B, C) -> R) -> (A) -> (B) -> (C) -> (R) {
    return { a in { b in { c in f(a,b,c) } } }
}

func curry<A,B,C,D,R>(_ f: @escaping (A, B, C, D) -> R) -> (A) -> (B) -> (C) -> (D) -> (R) {
    return { a in { b in { c in { d in f(a,b,c,d) } } } }
}

func curry<A,B,C,D,E,R>(_ f: @escaping (A, B, C, D, E) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (R) {
    return { a in { b in { c in { d in { e in f(a,b,c,d,e) } } } } }
}

func curry<A,B,C,D,E,F,R>(_ fx: @escaping (A, B, C, D, E, F) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (R) {
    return { a in { b in { c in { d in { e in { f in fx(a,b,c,d,e,f) } } } } } }
}

//MARK:- logic functions
func equalTo<A: Equatable>(_ elem: A) -> (A) -> Bool {
    return { otherElem in elem == otherElem }
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

//MARK:- composition function
precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator << : CompositionPrecedence
func << <T,U,V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { f(g($0)) }
}

prefix operator >
prefix func > <A>(_ value: A) -> (A) -> Bool where A: Comparable {
    return { otherValue in otherValue > value }
}
