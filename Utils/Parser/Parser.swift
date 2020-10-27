//
//  Parser.swift
//  Previando
//
//  Created by Franco Consoni on 18/10/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Json = JSON

class Parser {
    static func toString(_ json: Json) -> String {
        return json.stringValue
    }
    
    static func toInt(_ json: Json) -> Int {
        return json.intValue
    }
    
    static func toDouble(_ json: Json) -> Double {
        return json.doubleValue
    }
    
    static func toBool(_ json: Json) -> Bool {
        return json.boolValue
    }
    
    static func toDateMiliseconds(_ json: Json) -> Date {
        return Date(timeIntervalSince1970: toDouble(json))
    }
    
    static func toDateSeconds(_ json: Json) -> Date {
        return Date(timeIntervalSince1970: toDouble(json) / 1000)
    }
    
    static func toArray(_ json: Json) -> [Json] {
        return json.arrayValue
    }
    
    static func toJson(_ key: String) -> (Json) -> Json {
        return { json in json[key] }
    }
    
    static func hasKey(_ key: String) -> (Json) -> Bool {
        return { !$0.isEmpty } << toJson(key)
    }
    
    static func clLocationFrom(_ json: Json) -> CLLocationCoordinate2D {
        let latitude = (toDouble << toJson("latitude")) (json)
        let longitude = (toDouble << toJson("longitude")) (json)
        
        return CLLocationCoordinate2D(latitude: latitude.truncate(places: 7), longitude: longitude.truncate(places: 7))
    }
}

