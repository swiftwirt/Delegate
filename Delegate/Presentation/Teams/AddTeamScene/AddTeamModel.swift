//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

struct CreateTeamModel {
    
    var id: String?
    var title: String?
    var dateCreated: Date?
    var teamDetails: String?
    var members: [TeamMember]?
    var teamPhoto: CreateImageModel?

    var isValid: Bool {
        return !title.isNilOrEmpty
    }
}

extension CreateTeamModel {
    
    init(team: Team) {
        self.id = team.id
        self.title = team.title
        self.dateCreated = team.dateCreated
        self.teamDetails = team.details
        self.members = team.members
        if let url = team.logoLink {
            self.teamPhoto = .url(url)
        }
    }
}
