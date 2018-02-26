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
    var teamPhotoLink: URL?
    var teamPhoto: UIImage?

    var isValid: Bool {
        return id != nil && !title.isNilOrEmpty && dateCreated != nil && !teamDetails.isNilOrEmpty
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
            self.teamPhotoLink = URL(string: url)
        }
    }
}
