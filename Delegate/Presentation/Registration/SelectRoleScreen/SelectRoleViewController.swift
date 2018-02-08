//
//  SelectRoleViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

class SelectRoleViewController: DelegateAbstractViewController {
    
    // Containers
    
    @IBOutlet weak var sharkLogo: UIImageView!
    @IBOutlet weak var sharkTitleContainer: UILabel!
    @IBOutlet weak var sarkInspiringMessageContainer: UILabel!
    @IBOutlet weak var sharkButtonContainerr: UIView!
    
    @IBOutlet weak var keymenLogo: UIImageView!
    @IBOutlet weak var keymenTitleContainer: UILabel!
    @IBOutlet weak var keymenInspiringMessageContainer: UILabel!
    @IBOutlet weak var keymenButtonContainerr: UIView!
    
    @IBOutlet weak var separatorLineContainer: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [sharkLogo, sharkTitleContainer, sarkInspiringMessageContainer, sharkButtonContainerr, keymenLogo, keymenTitleContainer, keymenInspiringMessageContainer, keymenButtonContainerr], ofTheScreen: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: AnimationDuration.defaultFade) {
            self.separatorLineContainer.alpha = 1.0
        }
    }
    
    deinit {
        log.info("\(self) deinit")
    }
    
    @IBAction func onPressedCreateEnterprise(_ sender: Any)
    {
    }
    
    @IBAction func onPressedJoinTeam(_ sender: Any)
    {
        animate(views: [sharkLogo, sharkTitleContainer, sarkInspiringMessageContainer, sharkButtonContainerr, keymenLogo, keymenTitleContainer, keymenInspiringMessageContainer, keymenButtonContainerr], ofTheScreen: false)
        UIView.animate(withDuration: AnimationDuration.defaultFade) {
            self.separatorLineContainer.alpha = 0.0
        }
        Timer.after(0.8) {
            ApplicationRouter.showMainScreen()
        }
    }
}
