//
//  ExternalLearnerCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class ExternalLearnerCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePictureImageView.maskCircle(anyImage: UIImage(named: "profilePic")!)
    }

    
}
