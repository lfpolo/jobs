//
//  UIFontExtensions.swift
//  Events
//
//  Created by Luís Felipe Polo on 19/01/21.
//
import UIKit

extension UIFont {
  static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
    return metrics.scaledFont(for: font)
  }
}
