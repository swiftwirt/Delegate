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
    static let emailAddress = "emailAddress"
    static let id = "id"
    static let url = "url"
    static let picture = "picture"
    static let data = "data"
    
    // linkedIn
    static let lastName = "lastName"
    static let pictureUrl = "pictureUrl"
    static let firstName = "firstName"
}

enum Color {
    
    static let textFieldPlaceholder: UIColor = .white
    static let textFieldHighlighted: UIColor = .orange
    
    static let dark: UIColor = .black
    
    static let blue = UIColor(redPart: 85, greenPart: 172, bluePart: 255)
    static let red = UIColor(redPart: 255, greenPart: 38, bluePart: 0)
    static let green = UIColor(redPart: 0, greenPart: 158, bluePart: 131)
    
    static let orange = UIColor.orange
    
    static func getPageControlDotColor(pageNumber: Int) -> UIColor
    {
        switch pageNumber {
        case 0:
            return Color.orange
        case 1:
            return Color.blue
        case 2:
            return Color.red
        case 3:
            return Color.green
        default:
            return UIColor.white
        }
    }
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
    static let username = "Username"
    static let email = "Email"
    static let password = "Password"
    static let repeatPassword = "Repeat password"
    
    // Titles
    static let next = "Next"
    
    // Teams
    static let myTeams = "My Teams"
    static let invited = "Invited"
    static let invites = "Invites"
    
    // Image Picker
    static let photoActionSheetTitle = "Choose image"
    static let cameraTitle = "Camera"
    static let galleryTitle = "Gallery"
    static let cancelTitle = "Cancel"
}

enum AnimationDuration {
    
    static let defaultSlide: Double = 0.4
    static let defaultFade: Double = 0.6
}

enum ErrorMessage {
    
    static let messagePresentationDuration = 2.5
    
    static let error = "Error"
    static let errorUnknown = "Unknown error occured!"
    static let warning = "Warning"
    
    // Password/Email validation
    static let enterUsername = "Enter username"
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
    
    static let linkedInCanceled  = "LinkedIn login canceled"
    
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
    
    // Camera
    static let noCameraTitle = "No Camera title"
    static let noCameraMessage = "Sorry, this device has no camera title"
    
    // Settings
    static let noUsername = "Add username"
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

enum FirebaseKey: String {
    
    case id = "id"
    case naviteUser = "naviteUser"
    case userName = "userName"
    case firstName = "firstName"
    case lastName = "lastName"
    case email = "email"
    case password = "password"
    case birthDate = "birthDate"
    case avatarLink = "avatarLink"
    case users = "users"
    case uid = "uid"
    
    case settings = "settings"
    case needsAds = "needsAds"
    case congratulations = "congratulations"
    case push = "push"
    case localNotifications = "localNotifications"
    
    // Team
    case state = "state"
    case title = "title"
    case details = "details"
    case members = "members"
    case logoLink = "logoLink"
    
    case invitePending = "invitePending"
    case inviteAccepted = "inviteAccepted"
    case userCreated = "userCreated"

    // Team menber
    case name = "name"
    case tasks = "tasks"
    case position = "position"
    case userNotInvited = "userNotInvited"
    
    // Task
    case estimatedTime = "estimatedTime"
    case spentTime = "spentTime"
    case priority = "priority"
    case dueDate = "dueDate"
    case authorID = "authorID"
    case authorName = "authorName"
    case assigneeID = "assigneeID"
    case assigneeName = "assigneeName"
    case progress = "progress"
    case status = "status"
    case comments = "comments"
    case disscussion = "disscussion"
    
    case assigned = "assigned"
    case inPregress = "inPregress"
    case resolved = "resolved"
    case completed = "completed"
    
    case urgent = "urgent"
    case hight = "hight"
    case normal = "normal"
    case low = "low"
    
    // Message
    case text = "text"
    case dateCreated = "dateCreated"
    
}

enum ErrorResponseCode: Int {
    
    case requestCanceled = -999
    case noConnection = -1009
    case timeOutRequest = -1001
    case SSLError = -1200
}



