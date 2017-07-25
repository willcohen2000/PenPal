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
    
    static func initiateStartingData(targetLanguages tlangs: [Languages.LanguagesEnum], nativeLanguages natlangs: [Languages.LanguagesEnum], userInterests interests: [Interests.InterestsEnum], completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let uid = User.sharedInstance.uid else { return }
        let targetLanguageReference = Database.database().reference().child("TargetLanguages")
        let nativeLanguageReference = Database.database().reference().child("NativeLanguages")
        let interestsReference = Database.database().reference().child("Interests")
        
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
        
        var interestDict: [String:Bool] = [:]
        for (interest) in interests {
            interestDict[String(describing: interest)] = true
        }
        interestsReference.child(uid).updateChildValues(interestDict) { (error, ref) -> Void in
            if (error != nil) {
                MainFunctions.showErrorMessage(error: error!)
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
}
