//
//  CellIdentifiable.swift
//  Previando
//
//  Created by Franco Consoni on 21/08/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

protocol CellIdentifiable: class {
    static var identifier: String { get }
    static var nib: UINib? { get }
}

extension CellIdentifiable {
    static var identifier: String { String(describing: Self.self) }
    
    static var nib: UINib? { UINib(nibName: String(describing: Self.self), bundle: .none) }
}

//Mixin created to avoid boilerplate code
extension UICollectionView {
    func register<A: CellIdentifiable>(_ cellType: A.Type) {
        if cellType.nib.isEmpty() {
            self.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
        } else {
            self.register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
        }
    }
    
    func dequeue<A: CellIdentifiable & UICollectionViewCell>(_ cellType: A.Type, for indexPath: IndexPath) -> A? {
        return self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? A
    }
}

extension UITableView {
    func register<A: CellIdentifiable>(_ cellType: A.Type) {
        if cellType.nib.isEmpty() {
            self.register(cellType, forCellReuseIdentifier: cellType.identifier)
        } else {
            self.register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
        }
    }
    
    func dequeue<A: CellIdentifiable & UITableViewCell>(_ cellType: A.Type, for indexPath: IndexPath) -> A? {
        return self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? A
    }
}
