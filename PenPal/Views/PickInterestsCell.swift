//
//  PickInterestsCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol pickInterestDelegate {
    func interestSelected(_ interest: String)
}

protocol unpickInterestDelegate {
    func interestDeselected(_ interest: String)
}

class PickInterestsCell: UITableViewCell {
    
    @IBOutlet weak var pickInterestButton: UIButton!
    
    var interest: String!
    var pickDelegate: pickInterestDelegate?
    var unpickDelegate: unpickInterestDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    
    func configureCell(interest: String, isSelectedBool: Bool) {
        self.interest = interest
        self.pickInterestButton.setTitle(NSLocalizedString(String(describing: interest), comment: ""), for: .normal)
        if (isSelectedBool) {
            self.pickInterestButton.setTitleColor(Colors.primaryPurple, for: .normal)
            self.pickInterestButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 18.0)
        } else {
            self.pickInterestButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
            self.pickInterestButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 18.0)
        }
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @IBAction func interestButtonPressed(_ sender: Any) {
        if (pickInterestButton.titleColor(for: .normal) == Colors.primaryPurple) {
            self.pickInterestButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
            self.pickInterestButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 18.0)
            if unpickDelegate != nil {
                unpickDelegate?.interestDeselected(interest)
            }
        } else {
            if (PickInterestsController.userInterests.count != 4) {
                self.pickInterestButton.setTitleColor(Colors.primaryPurple, for: .normal)
                self.pickInterestButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 18.0)
                if pickDelegate != nil {
                    pickDelegate?.interestSelected(interest)
                }
            } else {
                if pickDelegate != nil {
                    pickDelegate?.interestSelected(interest)
                }
            }
        }
    }
    
}

