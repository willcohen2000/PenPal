//
//  PickInterestsCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol pickInterestDelegate {
    func interestSelected(_ interest: Interests.InterestsEnum)
}

protocol unpickInterestDelegate {
    func interestDeselected(_ interest: Interests.InterestsEnum)
}

class PickInterestsCell: UICollectionViewCell {
    
    @IBOutlet weak var pickInterestButton: UIButton!
    
    var interest: Interests.InterestsEnum!
    var pickDelegate: pickInterestDelegate?
    var unpickDelegate: unpickInterestDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickInterestButton.layer.cornerRadius = pickInterestButton.frame.height / 2
        self.frame.size.width = UIScreen.main.bounds.width - 20
        self.pickInterestButton.frame.size.width = UIScreen.main.bounds.width - 40
        pickInterestButton.layer.borderWidth = 0.5
        pickInterestButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func configureCell(interest: Interests.InterestsEnum) {
        self.interest = interest
        self.pickInterestButton.setTitle(String(describing: interest), for: .normal)
    }
 
    @IBAction func interestButtonPressed(_ sender: Any) {
        if (pickInterestButton.backgroundColor == selectedLanguageColor) {
            self.pickInterestButton.backgroundColor = UIColor.clear
            if unpickDelegate != nil {
                unpickDelegate?.interestDeselected(interest)
            }
        } else {
            self.pickInterestButton.backgroundColor = selectedLanguageColor
            if pickDelegate != nil {
                pickDelegate?.interestSelected(interest)
            }
        }
    }
    
}

