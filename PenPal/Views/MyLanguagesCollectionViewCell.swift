//
//  MyLanguagesCollectionViewCell.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class MyLanguagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var languageButton: UIButton!
    
    override func awakeFromNib() {
        self.frame.size.width = (UIScreen.main.bounds.width - 40)
        languageButton.layer.cornerRadius = (languageButton.layer.frame.height / 2)
        languageButton.layer.borderColor = UIColor.black.cgColor
        languageButton.layer.borderWidth = 0.5
    }
    
    @IBAction func languageButtonPressed(_ sender: Any) {
        
    }
    
}
