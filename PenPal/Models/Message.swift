//
//  Message.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import JSQMessagesViewController.JSQMessage

class Message {
    
    var key: String?
    let content: String
    let timestamp: Date
    let sender: Sender
    
    struct Sender {
        var uid: String!
        var name: String!
        
        init(uid: String, name: String) {
            self.uid = uid
            self.name = name
        }
        
    }
    
    lazy var jsqMessageValue: JSQMessage = {
        return JSQMessage(senderId: self.sender.uid,
                          senderDisplayName: self.sender.name,
                          date: self.timestamp,
                          text: self.content)
    }()
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.content = content
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.sender = Sender(uid: uid, name: username)
    }
    
    init(content: String) {
        self.content = content
        self.timestamp = Date()
        self.sender = Sender(uid: User.sharedInstance.uid, name: User.sharedInstance.name)
    }
    
    var dictValue: [String : Any] {
        let userDict = ["username" : sender.name,
                        "uid" : sender.uid]
        
        return ["sender" : userDict,
                "content" : content,
                "timestamp" : timestamp.timeIntervalSince1970]
    }
    
}

