//
//  SettingsScreenPresenter.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SettingsScreenPresenter {
    
    weak var output: SettingsTableViewController!
    
    var witchersChain: [UISwitch]
    {
        return [
            output.adsSwitcher,
            output.congratulationsSwitcher,
            output.localNotificationsSwitcher,
            output.pushSwitcher
            ]
    }
    
    func initialSetup(userName: String, email: String, settings: Settings? = nil)
    {
        output.userNameLabel.text = userName
        output.userEmailLabel.text = email
        guard settings != nil else { return }
        configureSwitchers(with: settings!)
    }
    
    fileprivate func configureSwitchers(with model: Settings)
    {
        output.adsSwitcher.isOn = model.needsAds
        output.congratulationsSwitcher.isOn = model.congratulations
        output.pushSwitcher.isOn = model.push
        output.localNotificationsSwitcher.isOn = model.localNotifications
    }
}
