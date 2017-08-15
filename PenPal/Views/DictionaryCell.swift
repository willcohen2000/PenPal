//
//  DictionaryCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class DictionaryCell: UITableViewCell {

    @IBOutlet weak var dictionaryWordLabel: UILabel!
    @IBOutlet weak var dictionaryDefinitionLabel: UILabel!
    
    func configureCell(dictionary: DictionaryEntry) {
        dictionaryWordLabel.text = dictionary.term
        dictionaryDefinitionLabel.text = dictionary.definition
    }

}
