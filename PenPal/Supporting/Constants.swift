//
//  Constants.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    struct CellIdentifier {
        static let homeCell: String = "HomeCell"
        static let editInterestCell: String = "editInterestCell"
        static let chatCell: String = "chatCell"
        static let correctionCell: String = "CorrectionCell"
        static let newTargetLanguageCell: String = "newTargetLanguageCell"
    }
    
    static let languageAbbreviations = [
        "english":"en",
        "french":"fr",
        "spanish":"es",
        "italin":"it",
        "japanese":"ja",
        "russian":"ru",
        "german":"de"
    ]
    
    struct Segues {
        static let targetLanguageSegue: String = "toTargetLanguagePick"
        static let nextSegue: String = "nextSegue"
        static let toSkillSegue: String = "toSkillLevelSegue"
        static let toChat: String = "toChat"
        static let toCorrections: String = "toCorrections"
        static let toFullCorrection: String = "toFullCorrection"
        static let toEditTargetLanguage: String = "toAddNewTargetLanguageSegue"
        static let loggedOutSegue: String = "loggedOutSegue"
    }
    
}
