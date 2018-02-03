//
//  ValidatableView.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class ValidatableView: UIView {

    var state: ValidationState = .undefined {
        didSet {
            handleAccordingToState()
        }
    }
    
    fileprivate func handleAccordingToState()
    {
        let tint: UIColor
        switch state {
        case .valid:
            tint = .green
        case .undefined:
            tint = .white
        default:
            tint = .orange
        }
        for view in self.subviews {
            view.tintColor = tint
            if view.isMember(of: UIView.self) {
                view.backgroundColor = tint
            }
        }
    }

}
