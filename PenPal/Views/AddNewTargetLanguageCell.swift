//
//  AddNewTargetLanguageCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

protocol pickNewTargetLanguageDelegate {
    func targetLanguageSelected(_ language: String)
}

protocol unpickNewTargetLanguageDelegate {
    func targetLanguageDeselected(_ language: String)
}

class AddNewTargetLanguageCell: UICollectionViewCell {
    
    @IBOutlet weak var pickLanguageButton: UIButton!
    
    var pickDelegate: pickNewTargetLanguageDelegate?
    var unpickDelegate: unpickNewTargetLanguageDelegate?
    let selectedLanguageColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.3)
    var language: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickLanguageButton.layer.cornerRadius = pickLanguageButton.frame.height / 2
        self.frame.size.width = UIScreen.main.bounds.width - 20
        self.pickLanguageButton.frame.size.width = UIScreen.main.bounds.width - 40
        pickLanguageButton.layer.borderWidth = 0.5
        pickLanguageButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func configureCell(language: String) {
        self.language = language
        self.pickLanguageButton.setTitle(NSLocalizedString(String(describing: language), comment: ""), for: .normal)
    }
    
    @IBAction func pickLanguageButtonPressed(_ sender: Any) {
        if (pickLanguageButton.backgroundColor == selectedLanguageColor) {
            self.pickLanguageButton.backgroundColor = UIColor.clear
            if let unpickDelegate = unpickDelegate {
                unpickDelegate.targetLanguageDeselected(self.language)
            }
        } else {
            self.pickLanguageButton.backgroundColor = selectedLanguageColor
            if let pickDelegate = pickDelegate {
                pickDelegate.targetLanguageSelected(self.language)
            }
        }
    }
    
    
}
