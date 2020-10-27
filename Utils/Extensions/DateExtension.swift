//
//  DateExtension.swift
//  Previando
//
//  Created by Franco Consoni on 27/08/2019.
//  Copyright © 2018 Kickser S.A. All rights reserved.
//

import Foundation

extension DateFormatter {
    func format(_ date: Date, as format: String) -> String {
        self.dateFormat = format
        
        return self.string(from: date)
    }
}
