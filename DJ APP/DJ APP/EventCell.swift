//
//  EventCell.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
