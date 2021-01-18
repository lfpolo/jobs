//
//  UIActivityIndicatorView+Extensions.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func setupIndicatorView(view : UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
                
        let horizontalConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
                
        let verticalConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
}
