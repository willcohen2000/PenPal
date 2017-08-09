//
//  MainFunctions.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainFunctions {
    
    // ADDS PADDING TO TEXT FIELDS SO TEXT IS NOT BLOCKED BY ICON
    static func extractLeftPadding(UIScreenWidth: Int) -> Int {
        switch(UIScreenWidth) {
        case 320:
            return 50
        case 375:
            return 60
        case 414:
            return 65
        default:
            return 0
        }
    }
    
    // LOADS SINGLETON DATA
    static func loadSingletonData(uid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        User.sharedInstance.uid = uid
        let nativeLanguageReference = Database.database().reference().child("NativeLanguages").child(uid)
        let targetLanguageReference = Database.database().reference().child("TargetLanguages").child(uid)
        let userReference = Database.database().reference().child("Users").child(uid)
        
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            User.sharedInstance.name = postDict["fullName"] as! String
            User.sharedInstance.imageUrl = postDict["profileImageUrl"] as! String
        })
        
        nativeLanguageReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                var languages: [String] = []
                for (language) in value {
                    languages.append(language.key as! String)
                }
                User.sharedInstance.nativeLanguages = languages
            }
            targetLanguageReference.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    var languages: [String] = []
                    for (language) in value {
                        languages.append(language.key as! String)
                    }
                    User.sharedInstance.targetLanguages = languages
                }
                completionHandler(true)
            })
        })
    }
    
    // ADD ERROR BORDER AROUND TEXT FIELD -> TAKE AWAY BORDER AROUND TEXT FIELD
    static func textFieldError(textFields: [UITextField]) {
        for (textField) in textFields {
            textField.layer.cornerRadius = textField.frame.size.height / 2
            textField.layer.borderColor = Colors.textFieldErrorRed.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
    
    static func textFieldTakeawayErrors(textFields: [UITextField]) {
        for (textField) in textFields {
            textField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    static func removeUserFromChatName(chatTitle: String) -> String {
        let userName = User.sharedInstance.name
        var updatedChatTitle: String = chatTitle
        if let range = chatTitle.range(of: userName!) {
            updatedChatTitle.removeSubrange(range)
        }
        let newChatTitle = updatedChatTitle.replacingOccurrences(of: ",", with: "")
        return newChatTitle
    }
    
    static func takeObjectOutOfStringArray(object: String, array: [String]) -> [String] {
        var newArray = array
        newArray.remove(at: newArray.index(of: object)!)
        return newArray
    }
    
    static func convertDateToReadable(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: time as Date)
    }
    
    // CREATE SIMPLE UIALERT WITHOUT ANY ADDED BUTTONS
    static func createSimpleAlert(alertTitle: String, alertMessage: String, controller: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message:
            alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    // SHOW ERROR ALERT AND INDIVIDUALIZE IT IN DEBUG CONSOLE
    static func showErrorMessage(error: Error) {
        print("==============================================================")
        print(error.localizedDescription)
        print("==============================================================")
    }
    
}
