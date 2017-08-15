//
//  DictionaryEntry.swift
//  PenPal
//
//  Created by Will Cohen on 8/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

class DictionaryEntry {
    
    var term = ""
    var definition = ""
    var postKey = ""
    
    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }
    
    init(postkey: String, postData: Dictionary<String, AnyObject>) {
        self.postKey = postkey
        
        if let term = postData["term"] as? String {
            self.term = term
        }
        if let definition = postData["definition"] as? String {
            self.definition = definition
        }
    }
    
}
