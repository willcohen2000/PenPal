//
//  CircleButtonImage.swift
//  PenPal
//
//  Created by Will Cohen on 7/25/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.setImage(anyImage, for: .normal)
    }
}
