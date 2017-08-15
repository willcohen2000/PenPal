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
    
    static func observeChats(for user: User = User.sharedInstance, withCompletion completion: @escaping (DatabaseReference, [Chat]) -> Void) -> DatabaseHandle {
        let ref = Database.database().reference().child("chats").child(user.uid)
        
        return ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion(ref, [])
            }
            
            let chats = snapshot.flatMap(Chat.init)
            completion(ref, chats)
        })
    }
    
    static func saveTranslation(userUID: String, correctionUID: String, translation: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let correctionReference = Database.database().reference().child("Corrections").child(userUID).child(correctionUID)
        correctionReference.updateChildValues([
            "translation":translation
        ]) { (error, ref) in
            if (error == nil) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func loadCorrections(userUID: String, completionHandler: @escaping (_ corrections: [Correction]) -> Void) {
        let correctionsReference = Database.database().reference().child("Corrections").child(userUID)
        var pulledCorrections = [Correction]()
        correctionsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for (snap) in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let correction = Correction(postkey: key, postData: postDict)
                        pulledCorrections.append(correction)
                    }
                }
            }
            completionHandler(pulledCorrections)
        })
    }
    
    static func saveUserInterests(userUID: String, interests: [String], completionHandler: @escaping (_ success: Bool) -> Void) {
        let userInterestReference = Database.database().reference().child("Users").child(userUID).child("Interests")
        userInterestReference.updateChildValues([
            "one": interests[0],
            "two": interests[1],
            "three": interests[2],
            "four": interests[3]
        ]) { (error, ref) in
            if (error == nil) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
        
    }
    
    static func saveUserTargetLanguages(userUID: String, targetLanguages: [String], completionHandler: @escaping (_ success: Bool) -> Void) {
        let targetLanguageReference = Database.database().reference().child("TargetLanguages").child(userUID)
        let languageReference = Database.database().reference().child("Languages")
        var targetLanguageDict = [String: Bool]()
        var allTargetLanguagesDict = [String:Bool]()
        for (language) in User.sharedInstance.targetLanguages {
            allTargetLanguagesDict[language] = true
        }
        for (language) in targetLanguages {
            targetLanguageDict[language] = true
            allTargetLanguagesDict[language] = true
        }

        targetLanguageReference.updateChildValues(targetLanguageDict) { (error, ref) in
            if (error == nil) {
                var counter = 0
                for (languageDict) in allTargetLanguagesDict {
                    languageReference.child(languageDict.key).child(userUID).child("TargetLangs").updateChildValues(allTargetLanguagesDict, withCompletionBlock: { (error, ref) in
                        if (error == nil) {
                            counter += 1
                            if (counter == targetLanguages.count) {
                                completionHandler(true)
                            }
                        }
                    })
                }
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func getUserIntrerests(userUID: String, completionHandler: @escaping (_ interests: [String]) -> Void) {
        let userInterestReference = Database.database().reference().child("Users").child(userUID).child("Interests")
        var pulledInterests = [String]()
        userInterestReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let interest = snap.value {
                        pulledInterests.append(interest as! String)
                    }
                }
            }
            completionHandler(pulledInterests)
        }) { (error) in
            MainFunctions.showErrorMessage(error: error)
            completionHandler([])
        }
    }
    
    static func postCorrection(forUserUID: String, fromUserName: String, originalMessage: String, correction: String, profileImageURL: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let postCorrectionReference = Database.database().reference().child("Corrections").child(forUserUID).childByAutoId()
        postCorrectionReference.updateChildValues([
            "fromUser": fromUserName,
            "timeOfCorrection": MainFunctions.convertDateToReadable(time: Date()),
            "originalMessage": originalMessage,
            "correction": correction,
            "profileImageURL": profileImageURL
        ]) { (error, ref) in
            if (error == nil) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
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
    
    static func retrieveDictionaryEntries(userUID: String, completionHandler: @escaping (_ dictionaryEntries: [DictionaryEntry]?) -> Void) {
        let userDictionaryReference = Database.database().reference().child("Dictionary").child(userUID)
        var dictEntries = [DictionaryEntry]()
        userDictionaryReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for (snap) in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let dictionaryEntry = DictionaryEntry(postkey: key, postData: postDict)
                        dictEntries.append(dictionaryEntry)
                    }
                }
            }
            completionHandler(dictEntries)
        }) { (error) in
            completionHandler(nil)
        }
    }
    
    static func uploadDictionaryEntry(userUID: String, entry: DictionaryEntry, completionHandler: @escaping (_ success: Bool) -> Void) {
        let userDictionaryReference = Database.database().reference().child("Dictionary").child(userUID)
        let dictionaryEntryDict = [
            "term": entry.term,
            "definition": entry.definition
        ]
        userDictionaryReference.childByAutoId().updateChildValues(dictionaryEntryDict) { (error, ref) in
            if (error == nil) {
                completionHandler(true)
            } else {
                if let error = error {
                    MainFunctions.showErrorMessage(error: error)
                }
                completionHandler(false)
            }
        }
    }
    
    static func findCompatibleUsers(targetLanguage: String, nativeLanguages: [String], completionHandler: @escaping (_ people: [String]) -> Void)  {
        let usersReference = Database.database().reference().child("Languages").child(targetLanguage)
        var userUIDs = [String]()
        usersReference.observeSingleEvent(of: .value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for (snap) in snapshot {
                    if let value = snap.value as? NSDictionary {
                        let userNativeLanguageDict = value["TargetLangs"] as? NSDictionary
                        if let userNativeLanguageDict = userNativeLanguageDict {
                            for (dict) in userNativeLanguageDict {
                                if (User.sharedInstance.nativeLanguages.contains(dict.key as! String)) {
                                    let compatibleUserUID = String(describing: value["uid"]!)
                                    if (compatibleUserUID != User.sharedInstance.uid) {
                                        userUIDs.append(compatibleUserUID)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completionHandler(userUIDs)
        })
    }
    
    static func loadSettingsProfilePicture(imageURL: String, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        if (imageURL == "") {
            if let addNewProfileImage = UIImage(named: "AddProfileImageIcon") {
                completionHandler(addNewProfileImage)
            }
        } else {
            let storageRef = Storage.storage().reference(forURL: imageURL)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if (error == nil) {
                    if let data = data {
                        if let profilePicImage = UIImage(data: data) {
                            completionHandler(profilePicImage)
                        }
                    }
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    static func saveByLanguages(targetLanguages: [String], nativeLanguages: [String]) {
        for (nativeLanguage) in nativeLanguages {
            let nativeLanguageReference = Database.database().reference().child("Languages").child(String(describing: nativeLanguage)).child(User.sharedInstance.uid)
            var targetLangsDict: [String:Bool] = [:]
            for (targetlanguage) in targetLanguages {
                targetLangsDict[String(describing: targetlanguage)] = true
            }
            nativeLanguageReference.updateChildValues(["uid":User.sharedInstance.uid,"TargetLangs":targetLangsDict])
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
 
        nativeLanguageReference.child(uid).updateChildValues(nativeLanguagesDict) { (error, ref) in
            if (error == nil) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    
    }
    
}
