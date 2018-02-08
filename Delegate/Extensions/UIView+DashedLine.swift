//
//  UIView+DashedLine.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addDashedBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat)
    {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
