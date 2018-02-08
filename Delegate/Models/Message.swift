//
//  Message.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message: Equatable {
    
    static func ==(lhs: Message, rhs: Message) -> Bool
    {
       return lhs.id == rhs.id
    }
    
    var id: String?
    var dateCreated: Date!
    var authorName: String?
    var authorAvatarLink: String?
    var text: String?
    
    init?(json: JSON)
    {
        if let unixDate = json[JSONKey.dateCreated].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        self.id = json[JSONKey.id].string
        self.authorName = json[JSONKey.name].string
        self.authorAvatarLink = json[JSONKey.avatarLink].string
        self.text = json[JSONKey.text].string
    }
}
