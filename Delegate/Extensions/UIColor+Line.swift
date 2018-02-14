//
//  UIColor+Line.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

extension UIColor {
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
