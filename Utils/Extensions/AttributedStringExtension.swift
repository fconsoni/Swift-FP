//
//  AttributedStringExtension.swift
//  Prebo
//
//  Created by Franco Consoni on 11/07/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import Foundation

extension NSAttributedString {
    func bold(ofSize size: CGFloat) -> NSAttributedString {
        let font = UIFont.appFontBold(ofSize: size)
        let newAttributedString = self.mutable()
        
        newAttributedString.addAttributes([.font: font], range: NSMakeRange(0, self.string.count))
        
        return newAttributedString
    }
    
    func withColor(_ color: UIColor) -> NSAttributedString {
        let newAttributedString = self.mutable()
        
        newAttributedString.addAttributes([.foregroundColor: color], range: NSMakeRange(0, self.string.count))
        
        return newAttributedString
    }
    
    func regular(ofSize size: CGFloat) -> NSAttributedString {
        let font = UIFont.appFontRegular(ofSize: size)
        let newAttributedString = self.mutable()
        
        newAttributedString.addAttributes([.font: font], range: NSMakeRange(0, self.string.count))
        
        return newAttributedString
    }
    
    func italic(ofSize size: CGFloat) -> NSAttributedString {
        let font = UIFont.appFontItalic(ofSize: size)
        let newAttributedString = self.mutable()
        
        newAttributedString.addAttributes([.font: font], range: NSMakeRange(0, self.string.count))
        
        return newAttributedString
    }
    
    func centered() -> NSAttributedString {
        let newAttributedString = self.mutable()
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        newAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, self.string.count))
        
        return newAttributedString
    }
    
    func mutable() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
    
    static func blank() -> NSAttributedString {
        return NSAttributedString(string: " ")
    }
}

infix operator +: AdditionPrecedence
func +(_ string: NSAttributedString, otherString: NSAttributedString) -> NSAttributedString {
    let newString = string.mutable()
    newString.append(otherString)
    
    return newString
}
