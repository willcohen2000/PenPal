//
//  Firebase+Service.swift
//  PenPal
//
//  Created by Will Cohen on 7/24/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseService {
    
    static func loadUsers(UIDs: [String], completionHandler: @escaping (_ people: [ExternalLearner]) -> Void) {
        let usersReference = Database.database().reference().child("Users")
        var users = [ExternalLearner]()
        for (uid) in UIDs {
            usersReference.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for (snap) in snapshot {
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let user = ExternalLearner(postkey: key, postData: postDict)
                            users.append(user)
                            if (users.count == 100) {
                                completionHandler(users)
                            }
                        }
                    }
                }

            })
        }
        completionHandler(users)
    }
    
    static func findCompatibleUsers(targetLanguage: String, nativeLanguages: [String], completionHandler: @escaping (_ people: [String]) -> Void)  {
        let usersReference = Database.database().reference().child("Languages").child(targetLanguage)
        var userUIDs = [String]()
        usersReference.observeSingleEvent(of: .value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for (snap) in snapshot {
                    if let value = snap.value as? NSDictionary {
                        userUIDs.append(String(describing: value["uid"]!))
                    }
                }
            }
            completionHandler(userUIDs)
        })
    }
    
    static func saveByLanguages(targetLanguages: [String], nativeLanguages: [String]) {
        for (nativeLanguage) in nativeLanguages {
            let nativeLanguageReference = Database.database().reference().child("Languages").child(String(describing: nativeLanguage)).childByAutoId()
            var targetLangsDict: [String:Bool] = [:]
            for (targetlanguage) in targetLanguages {
                targetLangsDict[String(describing: targetlanguage)] = true
            }
            nativeLanguageReference.updateChildValues(["uid":User.sharedInstance.uid,"NatLangs":targetLangsDict])
        }
    }
    
    static func saveInterestsInDatabase(uid: String, interests: [String], completionHandler: @escaping (_ success: Bool) -> Void) {
        let interestsReference = Database.database().reference().child("Users").child(uid).child("Interests")
        var counter = 0
        var keys = ["one","two","three","four"]
        for (interest) in interests {
            interestsReference.updateChildValues([keys[counter]:String(describing: interest)])
            counter += 1
        }
        completionHandler(true)
    }
    
    static func storeUserInDatabase(uid: String, name: String, profileImageUrl: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        Database.database().reference().child("Users").child(uid).updateChildValues(
            ["fullName": name,
             "uid": uid,
             "profileImageUrl": profileImageUrl]) { (error, ref) in
                if (error != nil) {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
    }
    
    static func initiateStartingData(targetLanguages tlangs: [String], nativeLanguages natlangs: [String], completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let uid = User.sharedInstance.uid else { return }
        let targetLanguageReference = Database.database().reference().child("TargetLanguages")
        let nativeLanguageReference = Database.database().reference().child("NativeLanguages")
        
        var targetLanguageDict: [String:Bool] = [:]
        for (language) in tlangs {
            targetLanguageDict[String(describing: language)] = true
        }
        targetLanguageReference.child(uid).updateChildValues(targetLanguageDict)
        
        var nativeLanguagesDict: [String:Bool] = [:]
        for (language) in natlangs {
            nativeLanguagesDict[String(describing: language)] = true
        }
        nativeLanguageReference.child(uid).updateChildValues(nativeLanguagesDict)
    
    }
    
}
