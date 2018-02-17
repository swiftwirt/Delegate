//
//  UserDetailsViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/17/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import RxSwift
import RxCocoa

class UserDetailsViewController: UITableViewController {
    
    enum FieldIndex {
        static let username = 0
        static let firstname = 1
        static let lastname = 2
        static let email = 3
        static let password = 4
    }

    @IBOutlet weak var lastNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var firstNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var usernameTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    
    fileprivate let userService = ApplicationManager.instance().userService
    fileprivate let apiService = ApplicationManager.instance().apiService
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInFields()
        setupTextFields()
    }
    
    fileprivate func setupTextFields() {
        let responderChain: [UITextField] = [usernameTextField,
                                             firstNameTextField,
                                             lastNameTextField,
                                             emailTextField]
        
        for (index, responder) in responderChain.enumerated() {
            let endEditingEvent: ControlEvent<Void>?
            
            switch responder {
            case let control as UIControl:
                endEditingEvent = control.rx.controlEvent(.editingDidEndOnExit)
            default:
                endEditingEvent = nil
            }
            
            endEditingEvent?.subscribe(onNext: { [unowned self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                switch index {
                case FieldIndex.username:
                    _ = self.apiService.updateUser(property: FirebaseKey.userName, value: responder.text).subscribe(onCompleted: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }).disposed(by: self.disposeBag)
                    _ = responderChain[index + 1].becomeFirstResponder()
                case FieldIndex.firstname:
                    _ = self.apiService.updateUser(property: FirebaseKey.firstName, value: responder.text).subscribe(onCompleted: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }).disposed(by: self.disposeBag)
                    _ = responderChain[index + 1].becomeFirstResponder()
                case FieldIndex.lastname:
                    _ = self.apiService.updateUser(property: FirebaseKey.lastName, value: responder.text).subscribe(onCompleted: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }).disposed(by: self.disposeBag)
                    _ = responderChain[index + 1].becomeFirstResponder()
                case FieldIndex.email:
                    _ = self.apiService.updateUser(property: FirebaseKey.email, value: responder.text).subscribe(onCompleted: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }).disposed(by: self.disposeBag)
                    _ = responderChain[index + 1].becomeFirstResponder()
                default:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    _ = responder.resignFirstResponder()
                }
                
            }).disposed(by: disposeBag)
        }
    }
    
    fileprivate func fillInFields()
    {
        if let username = userService.user?.userName {
            usernameTextField.text = username
        }
        
        if let firstname = userService.user?.firstName {
            firstNameTextField.text = firstname
        }
        
        if let lastname = userService.user?.lastName {
            lastNameTextField.text = lastname
        }
        
        if let email = userService.email {
            emailTextField.text = email
        }
    }
}
