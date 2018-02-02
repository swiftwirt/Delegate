//
//  Utils.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

enum JSONKey {
    
    static let email = "email"
}

enum Color {
    
    static let textFieldPlaceholder: UIColor = .white
    static let textFieldHighlighted: UIColor = .orange
    
    static let dark: UIColor = .black
    
}

enum Strings {
    
    // Placeholders
    static let email = "Email"
    static let password = "Password"
    static let repeatPassword = "Repeat password"
    
    // Titles
    static let next = "Next"
}

enum AnimationDuration {
    
    static let defaultSlide: Double = 0.4
}

enum ErrorMessage {
    
    static let error = "Error"
    static let errorUnknown = "Unknown error occured!"
    static let warning = "Warning"
    
    // Password/Email validation
    static let emailEmpty = "Enter email"
    static let emailIncorrectFormat = "Wrong email format"
    
    static let passwordEmpty = "Enter password"
    static let confirmPasswordEmpty = "Confirm password"
    static let passwordIdentity = "Password not match"
    static let passwordIncorrectFormat = "Wrong password format"
    
    
    static let fbLoginCanceled = "Facebook login canceled"
    static let fbLoginFailed = "Facebook login failed"
    
    static let loginFailed = "Login failed"
    
    // Remote responce
    static let noUserFound = "User not registered"
    static let emailTaken = "User already exists"
    static let wrongPassword = "Wrong password"
    
    // Internet condition
    static let noInternetTitle = "No Connection"
    static let noInternetSubtitle = "Internet connection appears to be offline."
    
    static let slowInternetTitle = "Slow Internet"
    static let slowInternetSubtitle = "This may cause unstable application performance"
    
    static let troublesInternetTitle = "Connection problems"
    static let troublesInternetSubtitle = "For some reasons internet seems to get lost"
}



