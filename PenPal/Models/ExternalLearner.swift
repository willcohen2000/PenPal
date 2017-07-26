//
//  ExternalLearner.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

class ExternalLearner {
    
    var name: String!
    var interests: [String:String]!
    var imageURL: String!
    var postKey: String!
    
    init(name: String, interests: [String:String], imageURL: String, postKey: String) {
        self.name = name
        self.interests = interests
        self.imageURL = imageURL
        self.postKey = postKey
    }
    
    init(postkey: String, postData: Dictionary<String, AnyObject>) {
        self.postKey = postkey
        
        if let name = postData["fullName"] as? String {
            self.name = name
        }
        if let imageURL = postData["profileImageUrl"] as? String {
            self.imageURL = imageURL
        }
        if let interests = postData["Interests"] as? [String:String] {
            self.interests = interests
        }
        
    }
    
}
