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

protocol flaggedUserDelegate {
    func flaggedUser(_ user: String)
}

class ExternalLearnerCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var interestLabelOne: UILabel!
    @IBOutlet weak var interestLabelTwo: UILabel!
    @IBOutlet weak var interestLabelThree: UILabel!
    @IBOutlet weak var interestLabelFour: UILabel!
    @IBOutlet weak var talkWithPersonButton: UIButton!
    @IBOutlet weak var likesToTalkAboutLabel: UILabel!
    
    var clickedTalkToUserDelegate: clickedTalkToUser?
    var flaggedUserDelegate: flaggedUserDelegate?
    var person: ExternalLearner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(person: ExternalLearner) {
        self.person = person
        
        if (person.imageURL == "") {
            profilePictureImageView.image = UIImage(named: "NoProfileImg")
            profilePictureImageView.maskImageWithImage()
        } else {
            profilePictureImageView.kf.setImage(with: URL(string: person.imageURL))
            profilePictureImageView.maskImageWithImage()
        }
        userNameLabel.text = "\(person.name!)"
        likesToTalkAboutLabel.text = NSLocalizedString("Likes to talk about:", comment: "Likes to talk about")
        interestLabelOne.text = "- \(NSLocalizedString(person.interests["one"]!, comment: ""))"
        interestLabelTwo.text = "- \(NSLocalizedString(person.interests["two"]!, comment: ""))"
        interestLabelThree.text = "- \(NSLocalizedString(person.interests["three"]!, comment: ""))"
        interestLabelFour.text = "- \(NSLocalizedString(person.interests["four"]!, comment: ""))"
        talkWithPersonButton.setTitle("\(NSLocalizedString("Talk with", comment: "Talk with/to")) \(person.name!)", for: .normal)
    }
    
    @IBAction func flagUserButtonPressed(_ sender: Any) {
        if let flaggedUserDelegate = flaggedUserDelegate {
            flaggedUserDelegate.flaggedUser(person.postKey)
        }
    }
    
    @IBAction func talkWithPersonButtonPressed(_ sender: Any) {
        if clickedTalkToUserDelegate != nil {
            clickedTalkToUserDelegate?.clickedTalkToUser(person)
        }
    }
    
}

