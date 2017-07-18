//
//  ExternalLearner.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

class ExternalLearner {
    
    var name: String
    var targetLanguages: [Languages.LanguagesEnum]
    var nativeLanguages: [Languages.LanguagesEnum]
    var country: String
    
    init(userFullname name: String, languagesUserWantsToLearn targetLanguages: [Languages.LanguagesEnum], languagesUserAlreadyKnows nativeLanguages: [Languages.LanguagesEnum], countryUserLivesIn country: String) {
        self.name = name
        self.targetLanguages = targetLanguages
        self.nativeLanguages = nativeLanguages
        self.country = country
    }
    
}
