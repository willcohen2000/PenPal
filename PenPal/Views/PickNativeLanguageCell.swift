//
//  PickNativeLanguageCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

protocol pickNativeLanguageDelegate {
    func nativeLanguageSelected(_ language: Languages.LanguagesEnum)
}

protocol unpickNativeLanguageDelegate {
    func nativeLanguageDeselected(_ language: Languages.LanguagesEnum)
}

class PickNativeLanguageCell: UICollectionViewCell {
    
    @IBOutlet weak var pickNativeLanguageButton: UIButton!
    
    var pickDelegate: pickNativeLanguageDelegate?
    var unpickDelegate: unpickNativeLanguageDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    var language: Languages.LanguagesEnum!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickNativeLanguageButton.layer.cornerRadius = pickNativeLanguageButton.frame.height / 2
        self.frame.size.width = UIScreen.main.bounds.width - 20
        self.pickNativeLanguageButton.frame.size.width = UIScreen.main.bounds.width - 40
        pickNativeLanguageButton.layer.borderWidth = 0.5
        pickNativeLanguageButton.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func configureCell(language: Languages.LanguagesEnum) {
        self.language = language
        self.pickNativeLanguageButton.setTitle(String(describing: language), for: .normal)
    }
    
    
    @IBAction func pickNativeLanguageButtonPressed(_ sender: Any) {
        if (pickNativeLanguageButton.backgroundColor == selectedLanguageColor) {
            self.pickNativeLanguageButton.backgroundColor = UIColor.clear
            print("94985")
            if pickDelegate != nil {
                pickDelegate?.nativeLanguageSelected(language)
                print("94985")
            }
        } else {
            self.pickNativeLanguageButton.backgroundColor = selectedLanguageColor
            if let unpickDelegate = unpickDelegate {
                unpickDelegate.nativeLanguageDeselected(self.language)
            }
        }
    }
    
}