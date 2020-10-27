//
//  UIView+Extension.swift
//  Previando
//
//  Created by Alejandro Ravasio on 28/06/2018.
//  Copyright © 2018 Kickser S.A. All rights reserved.
//

import Foundation

extension UIView {
	//MARK:- IBInspectables
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func addShadow(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = radius/4
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
    }
}

extension UIView {
    var identifier: String {
        get {
            return self.accessibilityIdentifier ?? ""
        }
        set {
            self.accessibilityIdentifier = newValue
        }
    }
    
    func view(withId identifier: String) -> UIView? {
        if self.identifier == identifier {
            return self
        } else {
            return self.subviews.compactMap{ $0.view(withId: identifier) }.first(where: equalTo(identifier) << { $0.identifier })
        }
    }
}
