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
    @IBOutlet var eventImageView: UIImageView!
    
    override func awakeFromNib() {
        eventImageView.layer.masksToBounds = true
        eventImageView.layer.cornerRadius = 10
        eventImageView.image = UIImage(named: "defaultImage")
        
    }
}
