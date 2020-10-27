//
//  TouchDownAnimatable.swift
//  Previando
//
//  Created by Franco Consoni on 03/01/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

protocol TouchDownAnimatable where Self: UIView {}

extension TouchDownAnimatable where Self: UIView {
    internal func animateTouchDown() {
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92)
            }, completion: { [weak self] _ in
                UIView.animate(withDuration: 0.06, animations: {
                    self?.transform = .identity
                })
        })
    }
}
