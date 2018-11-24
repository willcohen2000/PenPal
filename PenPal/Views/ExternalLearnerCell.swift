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
import SwiftyShadow

protocol clickedTalkToUser {
    func clickedTalkToUser(_ person: ExternalLearner)
}

protocol flaggedUserDelegate {
    func flaggedUser(_ user: String)
}

class ExternalLearnerCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var talkWithPersonButton: UIButton!
    @IBOutlet weak var likesToTalkAboutLabel: UILabel!
    @IBOutlet weak var innerCellView: UIView!
    
    var clickedTalkToUserDelegate: clickedTalkToUser?
    var flaggedUserDelegate: flaggedUserDelegate?
    var person: ExternalLearner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        innerCellView.layer.cornerRadius = 10
        innerCellView.layer.shadowRadius = 5
        innerCellView.layer.shadowOpacity = 0.3
        innerCellView.layer.shadowColor = UIColor.black.cgColor
        innerCellView.layer.shadowOffset = CGSize.zero
        innerCellView.generateOuterShadow()
        talkWithPersonButton.roundedButton()
    }
    
    func configureCell(person: ExternalLearner) {
        self.person = person

        talkWithPersonButton.clipsToBounds = true
        if (person.imageURL == "") {
            profilePictureImageView.image = UIImage(named: "NoProfileImg")
            profilePictureImageView.maskImageWithImage()
        } else {
            profilePictureImageView.kf.setImage(with: URL(string: person.imageURL))
            profilePictureImageView.maskImageWithImage()
        }
        userNameLabel.text = "\(person.name!)"
        interestsLabel.text = "\(NSLocalizedString(person.interests["one"]!, comment: "")), \(NSLocalizedString(person.interests["two"]!, comment: "")), \(NSLocalizedString(person.interests["three"]!, comment: "")), \(NSLocalizedString(person.interests["four"]!, comment: ""))"
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

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
