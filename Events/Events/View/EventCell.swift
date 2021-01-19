//
//  EventCell.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit

class EventCell : UITableViewCell {
    
    @IBOutlet var eventPrice: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var titleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleView: UIView!
    
    override func awakeFromNib() {
        titleView.alpha = 0.6
        titleView.layer.cornerRadius = 10
        titleView.layer.masksToBounds = true
    }
}
