//
//  ChatService.swift
//  PenPal
//
//  Created by Will Cohen on 8/7/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatService {
    
    static func create(from message: Message, with chat: Chat, completion: @escaping (Chat?) -> Void) {
        
        var membersDict = [String : Bool]()
        for uid in chat.memberUIDs {
            membersDict[uid] = true
        }
        
        let lastMessage = "\(message.sender.name!): \(message.content)"
        chat.lastMessage = lastMessage
        let lastMessageSent = message.timestamp.timeIntervalSince1970
        chat.lastMessageSent = message.timestamp
        
        let chatDict: [String : Any] = ["title" : chat.title,
                                        "memberHash" : chat.memberHash,
                                        "members" : membersDict,
                                        "lastMessage" : lastMessage,
                                        "lastMessageSent" : lastMessageSent]
        
        let chatRef = Database.database().reference().child("chats").child(User.sharedInstance.uid).childByAutoId()
        chat.key = chatRef.key

        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            multiUpdateValue["chats/\(uid)/\(chatRef.key)"] = chatDict
        }
        
        let messagesRef = Database.database().reference().child("messages").child(chatRef.key).childByAutoId()
        let messageKey = messagesRef.key
        
        multiUpdateValue["messages/\(chatRef.key)/\(messageKey)"] = message.dictValue
        
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            completion(chat)
        }
    }
    
    static func sendMessage(_ message: Message, for chat: Chat, success: ((Bool) -> Void)? = nil) {
        guard let chatKey = chat.key else {
            success?(false)
            return
        }
        
        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            let lastMessage = "\(message.sender.name!): \(message.content)"
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessage"] = lastMessage
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessageSent"] = message.timestamp.timeIntervalSince1970
        }
        
        let messagesRef = Database.database().reference().child("messages").child(chatKey).childByAutoId()
        let messageKey = messagesRef.key
        multiUpdateValue["messages/\(chatKey)/\(messageKey)"] = message.dictValue
        
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue, withCompletionBlock: { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success?(false)
                return
            }
            
            success?(true)
        })
    }
    
    static func observeMessages(forChatKey chatKey: String, completion: @escaping (DatabaseReference, Message?) -> Void) -> DatabaseHandle {
        let messagesRef = Database.database().reference().child("messages").child(chatKey)
        
        return messagesRef.observe(.childAdded, with: { snapshot in
            guard let message = Message(snapshot: snapshot) else {
                return completion(messagesRef, nil)
            }
            completion(messagesRef, message)
        })
    }
    
    static func checkForExistingChat(with user: PublicUser, completion: @escaping (Chat?) -> Void) {
        let members = [user, PublicUser(name: User.sharedInstance.name, uid: User.sharedInstance.uid)]
        let hashValue = Chat.hash(forMembers: members)
        
        let chatRef = Database.database().reference().child("chats").child(User.sharedInstance.uid)
        
        let query = chatRef.queryOrdered(byChild: "memberHash").queryEqual(toValue: hashValue)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let chatSnap = snapshot.children.allObjects.first as? DataSnapshot,
                let chat = Chat(snapshot: chatSnap)
                else { return completion(nil) }
            
            completion(chat)
        })
    }
    
}


