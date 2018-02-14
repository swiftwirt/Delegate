//
//  SettingsTableViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/6/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var adsSwitcher: UISwitch!
    @IBOutlet weak var congratulationsSwitcher: UISwitch!
    
    @IBOutlet weak var pushSwitcher: UISwitch!
    @IBOutlet weak var localNotificationsSwitcher: UISwitch!
    
    var output: SettingsScreenInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsConfigurator.configure(viewController: self)
        output.setupSwitchers() 
        output.initialSetup()
    }
    
    deinit {
        log.info("\(self) deinit")
    }

}
