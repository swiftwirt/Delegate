//
//  UIColor+HEX.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(redPart: Int, greenPart: Int, bluePart: Int, alpha: CGFloat = 1.0)
    {
        assert(redPart >= 0 && redPart <= 255, "Invalid red component")
        assert(greenPart >= 0 && greenPart <= 255, "Invalid green component")
        assert(bluePart >= 0 && bluePart <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(redPart) / 255.0, green: CGFloat(greenPart) / 255.0, blue: CGFloat(bluePart) / 255.0, alpha: alpha)
    }
    
    convenience init(hex: Int)
    {
        self.init(
            redPart: (hex >> 16) & 0xFF,
            greenPart: (hex >> 8) & 0xFF,
            bluePart: hex & 0xFF,
            alpha: 1.0
        )
    }
}
