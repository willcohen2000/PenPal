//
//  PickNativeLanguageCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol pickNativeLanguageDelegate {
    func nativeLanguageSelected(_ language: String)
}

protocol unpickNativeLanguageDelegate {
    func nativeLanguageDeselected(_ language: String)
}

class PickNativeLanguageCell: UITableViewCell {
    
    @IBOutlet weak var pickNativeLanguageButton: UIButton!
    
    var pickDelegate: pickNativeLanguageDelegate?
    var unpickDelegate: unpickNativeLanguageDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    var language: String!
    
    func configureCellSelected(language: String) {
        self.language = language
        self.pickNativeLanguageButton.setTitle(NSLocalizedString(String(describing: language), comment: ""), for: .normal)
        self.pickNativeLanguageButton.setTitleColor(Colors.primaryPurple, for: .normal)
    }
    
    func configureCellUnselected(language: String) {
        self.language = language
        self.pickNativeLanguageButton.setTitle(NSLocalizedString(String(describing: language), comment: ""), for: .normal)
        self.pickNativeLanguageButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
    }
    
    @IBAction func pickNativeLanguageButtonPressed(_ sender: Any) {
        if (pickNativeLanguageButton.titleColor(for: .normal) == Colors.primaryPurple) {
            self.pickNativeLanguageButton.setTitleColor(Colors.primaryPurpleFaded, for: .normal)
            self.pickNativeLanguageButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 18.0)
            if let unpickDelegate = unpickDelegate {
                unpickDelegate.nativeLanguageDeselected(self.language)
            }
        } else {
            self.pickNativeLanguageButton.setTitleColor(Colors.primaryPurple, for: .normal)
            self.pickNativeLanguageButton.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 18.0)
            if let pickDelegate = pickDelegate {
                pickDelegate.nativeLanguageSelected(self.language)
            }
        }
    }
    
}
