//
//  DictionaryCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import SwiftyShadow

class DictionaryCell: UITableViewCell {

    @IBOutlet weak var dictionaryWordLabel: UILabel!
    @IBOutlet weak var dictionaryDefinitionLabel: UILabel!
    @IBOutlet weak var dictionaryCellView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        dictionaryDefinitionLabel.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        dictionaryCellView.layer.cornerRadius = 10
        dictionaryCellView.layer.shadowRadius = 5
        dictionaryCellView.layer.shadowOpacity = 0.3
        dictionaryCellView.layer.shadowColor = UIColor.black.cgColor
        dictionaryCellView.layer.shadowOffset = CGSize.zero
        dictionaryCellView.generateOuterShadow()
    }
    
    func configureCell(dictionary: DictionaryEntry) {
        dictionaryWordLabel.text = dictionary.term
        dictionaryDefinitionLabel.text = dictionary.definition
    }

}
