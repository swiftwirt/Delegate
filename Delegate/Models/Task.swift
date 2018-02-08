//
//  Task.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Task: Equatable {
    
    static func ==(lhs: Task, rhs: Task) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    enum TaskStatus: String {
        case assigned = "assigned"
        case inPregress = "inPregress"
        case resolved = "resolved"
        case completed = "completed"
    }
    
    enum TaskPriority: String {
        case urgent = "urgent"
        case hight = "hight"
        case normal = "normal"
        case low = "low"
    }
    
    var id: String?
    var dateCreated: Date!
    var title: String?
    var details: String?
    var priority: TaskPriority?
    var estimatedTime: Double?
    var spentTime: Double?
    var dueDate: Date?
    var authorID: String?
    var authorName: String?
    var assigneeID: String?
    var assigneeName: String?
    var progress: Int?
    var status: TaskStatus?
    var comments: String?
    var disscussion: [Message]?
    
    init?(json: JSON)
    {
        if let unixDate = json[JSONKey.dateCreated].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        
        self.id = json[JSONKey.id].string
        self.title = json[JSONKey.title].string
        self.details = json[JSONKey.details].string
        self.estimatedTime = json[JSONKey.estimatedTime].double
        self.spentTime = json[JSONKey.spentTime].double
        self.authorID = json[JSONKey.authorID].string
        self.authorName = json[JSONKey.authorName].string
        self.assigneeID = json[JSONKey.assigneeID].string
        self.assigneeName = json[JSONKey.assigneeName].string
        self.progress = json[JSONKey.progress].int
        self.comments = json[JSONKey.comments].string
        
        if let priority = json[JSONKey.priority].string {
            self.priority = TaskPriority(rawValue: priority)
        }
        
        if let status = json[JSONKey.status].string {
            self.status = TaskStatus(rawValue: status)
        }
        
        if let unixDate = json[JSONKey.dueDate].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dueDate = convertedDate
        }
        
        guard let messagesArray = json[JSONKey.disscussion].array else { return }
        
        for json in messagesArray {
            if let message = Message(json: json), let disscussion = disscussion, !disscussion.contains(message) {
                self.disscussion?.append(message)
            }
        }
        
        self.disscussion = self.disscussion?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == .orderedAscending })
    }
}


