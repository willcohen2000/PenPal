//
//  ExternalLearnerCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol clickedTalkToUser {
    func clickedTalkToUser(_ person: ExternalLearner)
}

class ExternalLearnerCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var interestLabelOne: UILabel!
    @IBOutlet weak var interestLabelTwo: UILabel!
    @IBOutlet weak var interestLabelThree: UILabel!
    @IBOutlet weak var interestLabelFour: UILabel!
    @IBOutlet weak var talkWithPersonButton: UIButton!
    
    var clickedTalkToUserDelegate: clickedTalkToUser?
    var person: ExternalLearner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(person: ExternalLearner) {
        self.person = person
        if (person.imageURL == "") {
            profilePictureImageView.image = UIImage(named: "NoProfileImgf")
            profilePictureImageView.layer.masksToBounds = true
        } else {
            profilePictureImageView.kf.setImage(with: URL(string: person.imageURL))
            profilePictureImageView.maskImageWithImage()
        }
        userNameLabel.text = "\(person.name!)"
        interestLabelOne.text = "- \(person.interests["one"]!)"
        interestLabelTwo.text = "- \(person.interests["two"]!)"
        interestLabelThree.text = "- \(person.interests["three"]!)"
        interestLabelFour.text = "- \(person.interests["four"]!)"
        talkWithPersonButton.setTitle("Talk with \(person.name!)", for: .normal)
    }
    
    @IBAction func talkWithPersonButtonPressed(_ sender: Any) {
        if clickedTalkToUserDelegate != nil {
            clickedTalkToUserDelegate?.clickedTalkToUser(person)
        }
    }
    
}

