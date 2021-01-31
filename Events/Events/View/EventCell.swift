//
//  EventCell.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit

class EventCell : UITableViewCell {
    
    @IBOutlet var eventPriceLabel: UILabel!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDateLabel: UILabel!
    @IBOutlet var titleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleView: UIView!
    
    override func awakeFromNib() {
        eventTitleLabel.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        eventPriceLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        eventDateLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        titleView.alpha = 0.7
        titleView.layer.cornerRadius = 10
        titleView.layer.masksToBounds = true
        backgroundView = UIImageView(image: UIImage(named: "defaultImage"))
    }
}
