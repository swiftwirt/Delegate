//
//  UIViewController+ReturnBack.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func returnBack()
    {
        if let navigationController = self.navigationController {
            if navigationController.topViewController === navigationController.viewControllers[0] {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigationController.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
