//
//  OutgoingMessageCell.swift
//  PenPal
//
//  Created by Will Cohen on 11/25/18.
//  Copyright © 2018 Will Cohen. All rights reserved.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
