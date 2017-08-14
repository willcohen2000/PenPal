//
//  Correction.swift
//  PenPal
//
//  Created by Will Cohen on 8/9/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

class Correction {
    
    var correction: String!
    var correctionFromUserName: String!
    var originalMessage: String!
    var profileImageURL: String!
    var timeOfCorrection: String!
    var translation: String?
    var postKey: String!
    
    init(correction: String, correctionFromUserName: String, originalMessage: String, profileImageURL: String, postKey: String, timeOfCorrection: String, translation: String) {
        self.correction = correction
        self.correctionFromUserName = correctionFromUserName
        self.profileImageURL = profileImageURL
        self.timeOfCorrection = timeOfCorrection
        self.translation = translation
        self.postKey = postKey
    }
    
    init(postkey: String, postData: Dictionary<String, AnyObject>) {
        self.postKey = postkey
        
        if let correction = postData["correction"] as? String {
            self.correction = correction
        }
        if let correctionFromUserName = postData["fromUser"] as? String {
            self.correctionFromUserName = correctionFromUserName
        }
        if let originalMessage = postData["originalMessage"] as? String {
            self.originalMessage = originalMessage
        }
        if let profileImageURL = postData["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        if let timeOfCorrection = postData["timeOfCorrection"] as? String {
            self.timeOfCorrection = timeOfCorrection
        }
        if let translation = postData["translation"] as? String {
            self.translation = translation
        }
        
    }
    
}
