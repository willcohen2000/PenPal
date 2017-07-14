//
//  MainFunctions.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation

class MainFunctions {
    
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
    
    static func showErrorMessage(error: Error) {
        print("==============================================================")
        print(error.localizedDescription)
        print("==============================================================")
    }
    
}
