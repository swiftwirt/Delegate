//
//  ValidationService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SwiftyJSON

enum FirebaseError: LocalizedError {
    case unknownError
    case noFirebaseUserRegistered
    case invalidPassword
    case invalidEmail
    case accessRestricted
    case emailInUse
    case missingEmail
    case userRemoved
    
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return ErrorMessage.errorUnknown
        case .noFirebaseUserRegistered:
            return ErrorMessage.noUserFound
        case .invalidPassword:
            return ErrorMessage.wrongPassword
        case .accessRestricted:
            return ErrorMessage.accessRestricted
        case .invalidEmail:
            return ErrorMessage.emailIncorrectFormat
        case .emailInUse:
            return ErrorMessage.emailTaken
        case .missingEmail:
            return ErrorMessage.emailEmpty
        case .userRemoved:
            return ErrorMessage.userRemoved
        }
    }
}

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
    
    enum JSONErrorKey {
        static let errorCode = "error_code"
    }
    
    enum ErrorCode {
        static let noFirebaseUserRegistered = "17011"
        static let invalidPassword = "17009"
        static let noNetworkConnection = "17020"
        static let invalidEmail = "17008"
        static let accessRestricted = "17005"
        static let emailInUse = "17007"
        static let missingEmail = "17999"
    }
    
    func handle(remoteResponce error: Error?) throws
    {
        guard let error = error else { return }
        let firebaseError: FirebaseError

        let code = String(error.code)
        switch code {
        case ErrorCode.noFirebaseUserRegistered:
            firebaseError = FirebaseError.noFirebaseUserRegistered
            throw firebaseError
        case ErrorCode.invalidPassword:
            firebaseError = FirebaseError.invalidPassword
            throw firebaseError
        case ErrorCode.invalidEmail:
            firebaseError = FirebaseError.invalidEmail
            throw firebaseError
        case ErrorCode.accessRestricted:
            firebaseError = FirebaseError.accessRestricted
            throw firebaseError
        case ErrorCode.emailInUse:
            firebaseError = FirebaseError.emailInUse
            throw firebaseError
        case ErrorCode.missingEmail:
            firebaseError = FirebaseError.missingEmail
            throw firebaseError
        default:
            break
        }
    }
    
    // MARK: - Main methods
    
    fileprivate func handleFetchUserFromFirebase(with dictionary: [String: Any]?) throws
    {
        let error: FirebaseError
        guard let unwrappedDictionary = dictionary else {
            error = FirebaseError.userRemoved
            throw error
        }
    }
    
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
