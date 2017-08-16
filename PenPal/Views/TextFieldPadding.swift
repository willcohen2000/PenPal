//
//  TextFieldPadding.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class TextFieldPadding: UITextField {
    
    static var leftSidePaddingRatio: Float {
        get {
            if (UIScreen.main.bounds.width > 414) {
                return 0.10
            } else if (UIScreen.main.bounds.width == 1024.0) {
                return 0.20
            } else {
                return 0.15
            }
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: CGFloat(UIScreen.main.bounds.width * CGFloat(TextFieldPadding.leftSidePaddingRatio)), bottom: 0, right: 10);
    
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
