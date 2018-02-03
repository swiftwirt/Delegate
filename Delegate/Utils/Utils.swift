//
//  Utils.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit

enum Formatters {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

enum JSONKey {
    
    static let email = "email"
}

enum Color {
    
    static let textFieldPlaceholder: UIColor = .white
    static let textFieldHighlighted: UIColor = .orange
    
    static let dark: UIColor = .black
    
}

enum Constants {

    static let supportTitleCharactersMAX = 50
    static let supportPasswordCharactersMAX = 30
    static let supportDescriptionCharactersMAX = 300
    static let messagePresentationDuration = 3.0
    
    // Restoration
    static let needsRestoration = "NeedsRestoration"
    static let previouslyLaunched = "PreviouslyLaunched"
    
    // Password
    static let passwordRegex = "\\S{8,200}"
    //"^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    
    // Profile Details
    static let ageRange = 18 ..< 100
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
    
    static let messagePresentationDuration = 2.5
    
    static let error = "Error"
    static let errorUnknown = "Unknown error occured!"
    static let warning = "Warning"
    
    // Password/Email validation
    static let emailEmpty = "Enter email"
    static let emailIncorrectFormat = "Wrong email format"
    
    static let passwordEmpty = "Enter password"
    static let confirmPasswordEmpty = "Confirm password"
    static let passwordIdentity = "Passwords not match"
    static let passwordIncorrectFormat = "Wrong password format"
    
    static let accessRestricted = "Account access temporarily restricted!"
    static let userRemoved = "Account removed!"
    
    static let fbLoginCanceled = "Facebook login canceled!"
    static let fbLoginFailed = "Facebook login failed!"
    
    static let loginFailed = "Login failed"
    
    // Remote responce
    static let noUserFound = "User not registered!"
    static let emailTaken = "User already exists!"
    static let invalidCredentials = "Wrong email or password!"
    
    // Internet condition
    static let noInternetTitle = "No Connection"
    static let noInternetSubtitle = "Internet connection appears to be offline."
    
    static let slowInternetTitle = "Slow Internet"
    static let slowInternetSubtitle = "This may cause unstable application performance"
    
    static let troublesInternetTitle = "Connection problems"
    static let troublesInternetSubtitle = "For some reasons internet seems to get lost"
}

enum InfoMessage {
    
    static let success = "Success"
    
    static let getPasswordRestorationMessageFist = "We've sent an email to"
    static let getPasswordRestorationMessageLast = "Open it up and reset old password."
    
    static func getPasswordRestorationMessage(_ email: String) -> String
    {
        return  "\(getPasswordRestorationMessageFist) \(email). \(getPasswordRestorationMessageLast)"
    }
}

enum FirebaseKey {
    
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let password = "password"
    static let birthDate = "birthDate"
    static let avatarLink = "avatarLink"
    static let users = "users"
    static let uid = "uid"

}

enum ErrorResponseCode: Int {
    
    case requestCanceled = -999
    case noConnection = -1009
    case timeOutRequest = -1001
    case SSLError = -1200
}



