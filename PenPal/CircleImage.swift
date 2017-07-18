
//
//  CircleImage.swift
//  PenPal
//
//  Created by Will Cohen on 7/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
