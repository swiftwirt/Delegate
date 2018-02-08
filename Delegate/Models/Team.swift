//
//  Team.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Team: Equatable {
    
    static func ==(lhs: Team, rhs: Team) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    enum TeamState: String {
        case invitePending = "invitePending"
        case inviteAccepted = "inviteAccepted"
        case userCreated = "userCreated"
    }
    
    var id: String!
    var dateCreated: Date!
    var state: TeamState?
    var title: String?
    var details: String?
    var members: [TeamMember]?
    var logoLink: String?
    
    init?(with json: JSON)
    {
        guard let id = json[JSONKey.id].string else { return nil }
        self.id = id
        
        if let unixDate = json[JSONKey.dateCreated].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        
        self.title = json[JSONKey.title].string
        self.details = json[JSONKey.details].string
        self.logoLink = json[JSONKey.logoLink].string
        
        if let state = json[JSONKey.state].string {
            self.state = TeamState(rawValue: state)
        }
        
        guard let membersArray = json[JSONKey.members].array else { return }
        
        for json in membersArray {
            if let member = TeamMember(json: json), let members = members, !members.contains(member) {
                self.members?.append(member)
            }
        }
        
        self.members = self.members?.sorted(by: { $0.name.compare($1.name) == .orderedDescending })
    }
    
}
