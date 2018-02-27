//
//  ParametersConfigurator.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

struct ParametersConfigurator {
    
    static func userUpdateParameters(_ user: DLGUser) -> [String: Any]
    {
        var values = [String: Any]()
        
        values[FirebaseKey.naviteUser.rawValue] = user.naviteUser
        
        if let userName = user.userName {
            values[FirebaseKey.userName.rawValue] = userName
        }
        
        if let firstName = user.firstName {
            values[FirebaseKey.firstName.rawValue] = firstName
        }
        
        if let lastName = user.lastName {
            values[FirebaseKey.lastName.rawValue] = lastName
        }
        
        if let password = user.password {
            values[FirebaseKey.password.rawValue] = password
        }
        
        if let birthDate = user.birthDate?.description {
            values[FirebaseKey.birthDate.rawValue] = birthDate
        }
        
        if let email = user.email {
            values[FirebaseKey.email.rawValue] = email
        }
        
        if let avatarLink = user.avatarLink {
            values[FirebaseKey.avatarLink.rawValue] = avatarLink
        }
        
        if let uid  = user.uid  {
            values[FirebaseKey.uid.rawValue] = uid
        }
        
        if let settings  = user.settings  {
            values[FirebaseKey.settings.rawValue] = userSettingsUpdateParameters(settings)
        } 
        
        return values
    }
    
    static func userSettingsUpdateParameters(_ settings: Settings) -> [String: Any]
    {
        var values = [String: Any]()
        
        values[FirebaseKey.needsAds.rawValue] = settings.needsAds
        
        values[FirebaseKey.congratulations.rawValue] = settings.congratulations
        
        values[FirebaseKey.push.rawValue] = settings.push
        
        values[FirebaseKey.localNotifications.rawValue] = settings.localNotifications
        
        return values
    }
    
    static func parametersForTeam(_ team: Team) -> [String: Any]
    {
        var values = [String: Any]()
        
        if let title = team.title {
            values[FirebaseKey.title.rawValue] = title
        }
        
        if let details = team.details {
            values[FirebaseKey.details.rawValue] = details
        }
        
        if let logoLink = team.logoLink {
            values[FirebaseKey.logoLink.rawValue] = logoLink
        }
        
        if let members = team.members {
            values[FirebaseKey.members.rawValue] = ParametersConfigurator.paramersForTeamMembers(members)
        }
        
        return values
    }
    
    static func paramersForTeamMembers(_ members: [TeamMember]) -> [String: Any]
    {
        var values = [String: Any]()

        for member in members {
            
            values[FirebaseKey.id.rawValue] = member.id
            
            if let dateCreated = member.dateCreated {
                values[FirebaseKey.dateCreated.rawValue] = dateCreated
            }
            
            if let state = member.state?.rawValue {
                values[FirebaseKey.state.rawValue] = state
            }
            
            if let position = member.position {
                values[FirebaseKey.position.rawValue] = position
            }
            
            if let name = member.name {
                values[FirebaseKey.name.rawValue] = name
            }
            
            if let avatarLink = member.avatarLink {
                values[FirebaseKey.avatarLink.rawValue] = avatarLink
            }
            
            if let tasks = member.tasks {
                values[FirebaseKey.tasks.rawValue] = ParametersConfigurator.parametersForTasks(tasks)
            }
        }
        
        return values
    }
    
    static func parametersForTasks(_ tasks: [Task]) -> [String: Any]
    {
        var values = [String: Any]()
        
        for task in tasks {
            if let id = task.id {
                values[FirebaseKey.id.rawValue] = id
            }
            
            if let dateCreated = task.dateCreated {
                values[FirebaseKey.dateCreated.rawValue] = dateCreated
            }
            
            if let title = task.title {
                values[FirebaseKey.title.rawValue] = title
            }
            
            
            if let details = task.details {
                values[FirebaseKey.details.rawValue] = details
            }
            
            if let priority = task.priority {
                values[FirebaseKey.priority.rawValue] = priority.rawValue
            }
            
            if let estimatedTime = task.estimatedTime {
                values[FirebaseKey.estimatedTime.rawValue] = estimatedTime
            }
            
            if let spentTime = task.spentTime {
                values[FirebaseKey.spentTime.rawValue] = spentTime
            }
            
            if let dueDate = task.dueDate {
                values[FirebaseKey.dueDate.rawValue] = dueDate
            }
            
            if let authorID = task.authorID {
                values[FirebaseKey.authorID.rawValue] = authorID
            }
            
            if let authorName = task.authorName {
                values[FirebaseKey.authorName.rawValue] = authorName
            }
            
            if let assigneeID = task.assigneeID {
                values[FirebaseKey.assigneeID.rawValue] = assigneeID
            }
            
            if let assigneeName = task.assigneeName {
                values[FirebaseKey.assigneeName.rawValue] = assigneeName
            }
            
            if let progress = task.progress {
                values[FirebaseKey.progress.rawValue] = progress
            }
            
            if let status = task.status {
                values[FirebaseKey.status.rawValue] = status.rawValue
            }
            
            if let comments = task.comments {
                values[FirebaseKey.comments.rawValue] = comments
            }
            
        }
        
        return values
    }
}
