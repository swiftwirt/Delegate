//
//  ValidationService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PasswordValidationError: LocalizedError {
    
    case passwordIdentity
    case passwordEmpty
    case passworConfirmedEmpty
    case passwordIncorrectFormat
    
    public var errorDescription: String? {
        switch self {
        case .passwordIdentity:
            return ErrorMessage.passwordIdentity
        case .passwordEmpty:
            return ErrorMessage.passwordEmpty
        case .passworConfirmedEmpty:
            return ErrorMessage.confirmPasswordEmpty
        case .passwordIncorrectFormat:
            return ErrorMessage.passwordIncorrectFormat
        }
    }
}

enum EmailValidationError: LocalizedError {
    
    case emptyEmail
    case emailIncorrectFormat
    
    public var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return ErrorMessage.emailEmpty
        case .emailIncorrectFormat:
            return ErrorMessage.emailIncorrectFormat
        }
    }
}

enum ValidationState {
    case undefined
    case valid
    case invalid(errorMessage: String?)
}

class ValidationService: NSObject {
    
    func checkPasswords(_ password: String?, with confirmedPassword: String?) throws
    {
        let error: PasswordValidationError
        
        guard let password = password, password.count != 0 else {
            error = .passwordEmpty
            throw error
        }
        
        try validate(password: password)
        
        guard let confirmedPassword = confirmedPassword, confirmedPassword.count != 0 else {
            error = .passworConfirmedEmpty
            throw error
        }
        
        if password != confirmedPassword {
            error = .passwordIdentity
            throw error
        }
    }
    
    func validate(email: String?) throws
    {
        let error: EmailValidationError
        
        guard let email = email, email.count != 0 else {
            error = .emptyEmail
            throw error
        }
        
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailTest.evaluate(with: email) {
            error = .emailIncorrectFormat
            throw error
        }
    }
    
    func validate(password: String?) throws
    {
        let error: PasswordValidationError
        
        guard let password = password, password.count != 0 else {
            error = .passwordEmpty
            throw error
        }
        
        let passwordRegex = Constants.passwordRegex
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if !passwordTest.evaluate(with: password) {
            error = .passwordIncorrectFormat
            throw error
        }
    }
}
