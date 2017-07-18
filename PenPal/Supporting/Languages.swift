//
//  Languages.swift
//  PenPal
//
//  Created by Will Cohen on 7/14/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import Foundation
import UIKit

struct Languages {
   enum LanguagesEnum {
        case English
        case French
        case Spanish
        case Italian
        case Chinese
        case Japanese
        case Russian
        case German
    }
    
    static var languages: [LanguagesEnum] = [
        LanguagesEnum.English,
        LanguagesEnum.French,
        LanguagesEnum.Spanish,
        LanguagesEnum.Italian,
        LanguagesEnum.Japanese,
        LanguagesEnum.Russian,
        LanguagesEnum.German
    ]
    
}

