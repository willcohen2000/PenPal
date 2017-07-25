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
