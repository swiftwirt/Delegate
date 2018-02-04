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

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logoContainer: UIImageView!
    @IBOutlet weak var emailInputContainer: ValidatableView!
    @IBOutlet weak var resetButtonContainer: UIView!
    @IBOutlet weak var backButtonContainer: UIView!
    
    fileprivate let applicationManager = ApplicationManager.instance()
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let waitingTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaceholders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(views: [logoContainer, emailInputContainer, resetButtonContainer, backButtonContainer].reversed(), ofTheScreen: false)
    }
    
    fileprivate func configurePlaceholders()
    {
        emailTextField.becomeFirstResponder()
        emailTextField.setAttributed(placeholder: Strings.email, with: Color.textFieldPlaceholder)
    }
    
    @IBAction func onPressedResetButton(_ sender: Any)
    {
        do {
            try applicationManager.validationService.validate(email: emailTextField.text)
            emailInputContainer.state = .undefined
            applicationManager.apiService.resetPassword(for: emailTextField.text!).observeOn(MainScheduler.instance).subscribe(onCompleted: { [weak self] in
                guard let StrongSelf = self else { return }
                AlertHandler.showSpecialAlert(with: InfoMessage.success, message: InfoMessage.getPasswordRestorationMessage(StrongSelf.emailTextField.text!)) { action in
                    StrongSelf.handleReturnBack()
                }
            }).disposed(by: disposeBag)
        } catch {
            emailTextField.insertFieldValidationMessage(message: error.localizedDescription)
            emailInputContainer.state = .invalid(errorMessage: nil)
        }
    }
    
    fileprivate func handleReturnBack()
    {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.animate(views: [self.logoContainer, self.emailInputContainer, self.resetButtonContainer, self.backButtonContainer].reversed(), ofTheScreen: true)
            Timer.after(self.waitingTime) { [weak self] in
                self?.returnBack()
            }
        }
    }
    
    @IBAction func onPressedBackButton(_ sender: Any)
    {
        handleReturnBack()
    }
    
}
