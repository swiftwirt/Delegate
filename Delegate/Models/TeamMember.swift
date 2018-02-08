//
//  TeamMember.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TeamMemberState: String {
    case invitePending = "invitePending"
    case inviteAccepted = "inviteAccepted"
    case userNotInvited = "userNotInvited"
}

struct TeamMember: Equatable {
    
    static func ==(lhs: TeamMember, rhs: TeamMember) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    var id: String!
    var dateCreated: Date!
    var state: TeamMemberState?
    var position: String?
    var name: String?
    var avatarLink: String?
    var tasks: [Task]?
    
    init?(json: JSON)
    {
        guard let id = json[JSONKey.id].string else { return nil }
        self.id = id
        
        if let unixDate = json[JSONKey.dateCreated].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        
        if let state = json[JSONKey.state].string {
            self.state = TeamMemberState(rawValue: state)
        }
        
        self.name = json[JSONKey.name].string
        self.avatarLink = json[JSONKey.avatarLink].string
        self.position = json[JSONKey.position].string
        
        guard let tasksArray = json[JSONKey.tasks].array else { return }
        
        for json in tasksArray {
            if let task = Task(json: json), let tasks = tasks, !tasks.contains(task) {
                self.tasks?.append(task)
            }
        }
        
        self.tasks = self.tasks?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == .orderedAscending })
    }
}
