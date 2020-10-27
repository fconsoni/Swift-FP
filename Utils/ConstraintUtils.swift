//
//  ConstraintUtils.swift
//  Previando
//
//  Created by Franco Consoni on 16/07/2019.
//  Copyright © 2019 Kickser S.A. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
	
	static func fullPin(_ view: UIView, into superView: UIView) {
		activate([
			view.topAnchor.constraint(equalTo: superView.topAnchor),
			view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
			view.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
			view.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
		])
	}
}
