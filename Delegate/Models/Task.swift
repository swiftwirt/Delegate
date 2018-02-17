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
        if let unixDate = json[FirebaseKey.dateCreated.rawValue].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dateCreated = convertedDate
        } else {
            return nil
        }
        
        self.id = json[FirebaseKey.id.rawValue].string
        self.title = json[FirebaseKey.title.rawValue].string
        self.details = json[FirebaseKey.details.rawValue].string
        self.estimatedTime = json[FirebaseKey.estimatedTime.rawValue].double
        self.spentTime = json[FirebaseKey.spentTime.rawValue].double
        self.authorID = json[FirebaseKey.authorID.rawValue].string
        self.authorName = json[FirebaseKey.authorName.rawValue].string
        self.assigneeID = json[FirebaseKey.assigneeID.rawValue].string
        self.assigneeName = json[FirebaseKey.assigneeName.rawValue].string
        self.progress = json[FirebaseKey.progress.rawValue].int
        self.comments = json[FirebaseKey.comments.rawValue].string
        
        if let priority = json[FirebaseKey.priority.rawValue].string {
            self.priority = TaskPriority(rawValue: priority)
        }
        
        if let status = json[FirebaseKey.status.rawValue].string {
            self.status = TaskStatus(rawValue: status)
        }
        
        if let unixDate = json[FirebaseKey.dueDate.rawValue].double {
            let convertedDate = Date.init(timeIntervalSince1970: unixDate)
            self.dueDate = convertedDate
        }
        
        guard let messagesArray = json[FirebaseKey.disscussion.rawValue].array else { return }
        
        for json in messagesArray {
            if let message = Message(json: json), let disscussion = disscussion, !disscussion.contains(message) {
                self.disscussion?.append(message)
            }
        }
        
        self.disscussion = self.disscussion?.sorted(by: { $0.dateCreated.compare($1.dateCreated) == .orderedAscending })
    }
}


