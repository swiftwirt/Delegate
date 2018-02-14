//
//  SettingsConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class SettingsConfigurator {
    
    static func configure(viewController: SettingsTableViewController)
    {
        let interactor = SettingsScreenInteractor()
        viewController.output = interactor
        
        let presenter = SettingsScreenPresenter()
        interactor.output = presenter
        
        let router = SettingsScreenRouter()
        router.viewController = viewController
        interactor.input = router
        
        presenter.output = viewController
    }
    
}
