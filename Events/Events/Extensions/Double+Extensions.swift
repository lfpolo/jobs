//
//  DoubleExtension.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation

extension Double {
    var currencyString : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? String(self)
    }
}
