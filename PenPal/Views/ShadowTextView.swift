//
//  ShadowTextView.swift
//  PenPal
//
//  Created by Will Cohen on 8/8/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

class ShadowTextView: UITextView {
    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    
}
