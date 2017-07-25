//
//  MainFunctions.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

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
