//
//  PickLanguageCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol pickTargetLanguageDelegate {
    func targetLanguageSelected(_ language: String)
}

protocol unpickTargetLanguageDelegate {
    func targetLanguageDeselected(_ language: String)
}

class PickLanguageCell: UITableViewCell {

    @IBOutlet weak var pickLanguageButton: UIButton!
    
    var pickDelegate: pickTargetLanguageDelegate?
    var unpickDelegate: unpickTargetLanguageDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    var language: String!
    
    func configureCellSelected(language: String) {
        self.language = language
        self.pickLanguageButton.setTitle(NSLocalizedString(String(describing: language), comment: ""), for: .normal)
        self.pickLanguageButton.setTitleColor(Colors.primaryPurple, for: .normal)
    }
    
    func configureCellUnselected(language: String) {
        self.language = language
        self.pickLanguageButton.setTitle(NSLocalizedString(String(describing: language), comment: ""), for: .normal)
        self.pickLanguageButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
    }
    
    @IBAction func pickLanguageButtonPressed(_ sender: Any) {
        if (pickLanguageButton.titleColor(for: .normal) == Colors.primaryPurple) {
            self.pickLanguageButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
            self.pickLanguageButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 18.0)
            if let unpickDelegate = unpickDelegate {
                unpickDelegate.targetLanguageDeselected(self.language)
            }
        } else {
            self.pickLanguageButton.setTitleColor(Colors.primaryPurple, for: .normal)
            self.pickLanguageButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 18.0)
            if let pickDelegate = pickDelegate {
                pickDelegate.targetLanguageSelected(self.language)
            }
        }
    }
    
    
}



