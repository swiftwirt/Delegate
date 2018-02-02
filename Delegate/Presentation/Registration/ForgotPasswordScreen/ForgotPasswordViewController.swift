//
//  ForgotPasswordViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordViewController: DelegateAbstractViewController {

    @IBOutlet weak var logoContainer: UIStackView!
    @IBOutlet weak var emailInputContainer: UIView!
    @IBOutlet weak var resetButtonContainer: UIView!
    @IBOutlet weak var backButtonContainer: UIView!
    
    fileprivate let waitingTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [logoContainer, emailInputContainer, resetButtonContainer, backButtonContainer], ofTheScreen: false)
    }

    @IBAction func onPressedBackButton(_ sender: Any) {
        animate(views: [logoContainer, emailInputContainer, resetButtonContainer, backButtonContainer], ofTheScreen: true)
        Timer.after(waitingTime) {
            self.returnBack()
        }
    }
    
}
