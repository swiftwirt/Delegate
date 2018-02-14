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
    
    // Team
    static let state = "state"
    static let title = "title"
    static let details = "details"
    static let members = "members"
    static let logoLink = "logoLink"
    
    static let invitePending = "invitePending"
    static let inviteAccepted = "inviteAccepted"
    static let userCreated = "userCreated"
    
    // Team menber
    static let name = "name"
    static let avatarLink = "avatarLink"
    static let tasks = "tasks"
    static let position = "position"
    static let userNotInvited = "userNotInvited"
    
    // Task
    static let estimatedTime = "estimatedTime"
    static let spentTime = "spentTime"
    static let priority = "priority"
    static let dueDate = "dueDate"
    static let authorID = "authorID"
    static let authorName = "authorName"
    static let assigneeID = "assigneeID"
    static let assigneeName = "assigneeName"
    static let progress = "progress"
    static let status = "status"
    static let comments = "comments"
    static let disscussion = "disscussion"
    
    static let assigned = "assigned"
    static let inPregress = "inPregress"
    static let resolved = "resolved"
    static let completed = "completed"

    static let urgent = "urgent"
    static let hight = "hight"
    static let normal = "normal"
    static let low = "low"
    
    // Message
    static let text = "text"
    static let dateCreated = "dateCreated"
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
    static let photoActionSheetTitle = "Choose image title"
    static let cameraTitle = "Camera title"
    static let galleryTitle = "Gallery title"
    static let cancelTitle = "Cancel title"
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

enum FirebaseKey {
    
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let password = "password"
    static let birthDate = "birthDate"
    static let avatarLink = "avatarLink"
    static let users = "users"
    static let uid = "uid"
    
    static let settings = "settings"
    static let needsAds = "needsAds"
    static let congratulations = "congratulations"
    static let push = "push"
    static let localNotifications = "localNotifications"
    
}

enum ErrorResponseCode: Int {
    
    case requestCanceled = -999
    case noConnection = -1009
    case timeOutRequest = -1001
    case SSLError = -1200
}



