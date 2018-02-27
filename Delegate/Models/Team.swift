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
    
    var id: String?
    var dateCreated: Date!
    var title: String?
    var details: String?
    var members: [TeamMember]?
    var logoLink: String?
    
    init(with model: CreateTeamModel) {
        self.dateCreated = Date()
        self.title = model.title
        self.details = model.teamDetails
    }
    
    init?(with json: JSON)
    {
        guard let id = json[FirebaseKey.id.rawValue].string else { return nil }
        self.id = id
        
        if let unixDate = json[FirebaseKey.dateCreated.rawValue].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        
        self.title = json[FirebaseKey.title.rawValue].string
        self.details = json[FirebaseKey.details.rawValue].string
        self.logoLink = json[FirebaseKey.logoLink.rawValue].string
        
        guard let membersArray = json[FirebaseKey.members.rawValue].array else { return }
        
        for json in membersArray {
            if let member = TeamMember(json: json), let members = members, !members.contains(member) {
                self.members?.append(member)
            }
        }
        
        self.members = self.members?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == .orderedDescending })
    }
    
}
