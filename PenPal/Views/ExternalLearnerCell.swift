//
//  ExternalLearnerCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase

class ExternalLearnerCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var interestLabelOne: UILabel!
    @IBOutlet weak var interestLabelTwo: UILabel!
    @IBOutlet weak var interestLabelThree: UILabel!
    @IBOutlet weak var interestLabelFour: UILabel!
    
    var person: ExternalLearner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(person: ExternalLearner) {
        self.person = person
        profilePictureImageView.maskCircle(anyImage: UIImage(named: "profilePic")!)
        userNameLabel.text = "\(person.name!)"
        interestLabelOne.text = "- \(person.interests["one"]!)"
        interestLabelTwo.text = "- \(person.interests["two"]!)"
        interestLabelThree.text = "- \(person.interests["three"]!)"
        interestLabelFour.text = "- \(person.interests["four"]!)"
    }
    
}
