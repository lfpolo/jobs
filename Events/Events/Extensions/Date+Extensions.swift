//
//  DateExtension.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation

extension Date {
    var toString : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
