//
//  FrameUtils.swift
//  Previando
//
//  Created by Franco Consoni on 07/02/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

extension CGRect {
    func copy(x: CGFloat? = .none, y: CGFloat? = .none, width: CGFloat? = .none, height: CGFloat? = .none) -> CGRect {
        return CGRect(x: x.getOrElse(self.origin.x),
                      y: y.getOrElse(self.origin.y),
                      width: width.getOrElse(self.width),
                      height: height.getOrElse(self.height))
    }
}

extension CGSize {
    func copy(width: CGFloat? = .none, height: CGFloat? = .none) -> CGSize {
        return CGSize(width: width.getOrElse(self.width),
                      height: height.getOrElse(self.height))
    }
}

extension CGPoint {
    func isInside(of rect: CGRect) -> Bool {
        let isInsideHorizontally = [>rect.origin.x, >!(rect.origin.x + rect.width)].all(appliedTo(self.x))
        
        let isInsideVertically = [>rect.origin.y, >!(rect.origin.y + rect.height)].all(appliedTo(self.y))
        
        return isInsideHorizontally && isInsideVertically
    }
    
    func movedBy(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

extension UIEdgeInsets {
    func copy(top: CGFloat? = .none, left: CGFloat? = .none, bottom: CGFloat? = .none, right: CGFloat? = .none) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.getOrElse(self.top),
                            left: left.getOrElse(self.left),
                            bottom: bottom.getOrElse(self.bottom),
                            right: right.getOrElse(self.right))
    }
}
