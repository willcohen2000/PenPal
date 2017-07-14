//
//  TextFieldPadding.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class TextFieldPadding: UITextField {

    //320 -> 50
    //375 -> 60
    //414 -> 65
    
    let padding = UIEdgeInsets(top: 0, left: CGFloat(MainFunctions.extractLeftPadding(UIScreenWidth: Int(UIScreen.main.bounds.width))), bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
