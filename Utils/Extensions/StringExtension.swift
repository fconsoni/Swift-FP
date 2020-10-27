//
//  StringExtension.swift
//  Previando
//
//  Created by Franco Consoni on 18/08/19.
//  Copyright © 2018 Kickser S.A.. All rights reserved.
//

import Foundation

extension String {
    var local: String {
        return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
    }
    
    var underlined: NSMutableAttributedString {
        let textRange = NSMakeRange(0, self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        
        return attributedText
    }
    
    func bold(ofSize size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: self).bold(ofSize: size)
    }
    
    func italic(ofSize size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: self).italic(ofSize: size)
    }
    
    func withColor(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self).withColor(color)
    }
    
    func regular(ofSize size: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: self).regular(ofSize: size)
    }
    
    func fromBase64() -> String? {
        return Data(base64Encoded: self).flatMap{ String(data: $0, encoding: .utf8) }
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        return Result(try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)).getOrElse(NSAttributedString())
    }
    
    func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        
        return urlTest.evaluate(with: self)
    }
    
    static func randomNonce() -> String {
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = 32

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

extension NSString {
    @objc var local: NSString {
        return NSLocalizedString(self as String, tableName: "Localizable", value: "**\(self)**", comment: "") as NSString
    }
    
    @objc var bundleLocal: NSString {
        return NSLocalizedString(self as String, tableName: "InfoPlist", value: "**\(self)**", comment: "") as NSString
    }
}
