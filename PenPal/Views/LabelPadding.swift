//
//  LabelPadding.swift
//  PenPal
//
//  Created by Will Cohen on 11/25/18.
//  Copyright © 2018 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LabelPadding: UILabel {
    
    @IBInspectable var topInset: CGFloat = 16.0
    @IBInspectable var bottomInset: CGFloat = 16.0
    @IBInspectable var leftInset: CGFloat = 20.0
    @IBInspectable var rightInset: CGFloat = 20.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
