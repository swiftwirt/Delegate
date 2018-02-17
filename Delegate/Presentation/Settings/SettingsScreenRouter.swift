//
//  SettingsScreenRouter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SettingsScreenRouter {
    
    weak var viewController: SettingsTableViewController!
    
    func showSupportMessageScreen()
    {
        let supportService = ApplicationManager.instance().supportEmailService
        supportService.presentEmailController(inViewController: viewController)
    }
    
}
