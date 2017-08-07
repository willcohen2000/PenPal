//
//  User.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

final class User {
    static let sharedInstance = User()
    private init() { }
    
    var name: String!
    var targetLanguages: [String]!
    var nativeLanguages: [String]!
    var interests: [String]!
    var skillLevelInt: Int = 0
    var uid: String!
    var imageUrl: String!
    
}

class PublicUser {
    var name: String
    var uid: String
    
    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
    
}
