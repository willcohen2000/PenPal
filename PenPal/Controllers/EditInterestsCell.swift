//
//  EditInterestsCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol editInterestPickDelegate {
    func interestSelected(_ interest: String)
}

protocol editInterestUnpickDelegate {
    func interestDeselected(_ interest: String)
}

class EditInterestCell: UICollectionViewCell {
    
    @IBOutlet weak var pickInterestButton: UIButton!
    
    var interest: String!
    var pickDelegate: editInterestPickDelegate?
    var unpickDelegate: editInterestUnpickDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickInterestButton.layer.cornerRadius = pickInterestButton.frame.height / 2
        self.frame.size.width = UIScreen.main.bounds.width - 20
        self.pickInterestButton.frame.size.width = UIScreen.main.bounds.width - 40
        pickInterestButton.layer.borderWidth = 0.5
        pickInterestButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func configureCell(interest: String, isSelectedBool: Bool) {
        self.interest = interest
        self.pickInterestButton.setTitle(String(describing: interest), for: .normal)
        if (isSelectedBool) {
            self.pickInterestButton.backgroundColor = selectedLanguageColor
        } else {
            self.pickInterestButton.backgroundColor = UIColor.clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @IBAction func interestButtonPressed(_ sender: Any) {
        if (pickInterestButton.backgroundColor == selectedLanguageColor) {
            self.pickInterestButton.backgroundColor = UIColor.clear
            if unpickDelegate != nil {
                unpickDelegate?.interestDeselected(interest)
            }
        } else {
            if (EditInterestsController.userInterests.count != 4) {
                self.pickInterestButton.backgroundColor = selectedLanguageColor
                if pickDelegate != nil {
                    pickDelegate?.interestSelected(interest)
                }
            } else {
                self.pickInterestButton.backgroundColor = UIColor.clear
                if pickDelegate != nil {
                    pickDelegate?.interestSelected(interest)
                }
            }
        }
    }
    
}
