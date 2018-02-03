//
//  User.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

class DLGUser: NSObject, NSCoding {
    
    var userName: String? = nil
    var birthDate: Date? = nil
    var email: String? = nil
    var password: String? = nil
    var avatarLink: String? = nil
    var uid: String? = nil
    
    var vipPlanExpirationDate: Date? = nil
    
    required init?(coder aDecoder: NSCoder) {
        userName = aDecoder.decodeObject(forKey: FirebaseKey.userName) as? String
        email = aDecoder.decodeObject(forKey: FirebaseKey.email) as? String
        password = aDecoder.decodeObject(forKey: FirebaseKey.password) as? String
        avatarLink = aDecoder.decodeObject(forKey: FirebaseKey.avatarLink) as? String
        uid = aDecoder.decodeObject(forKey: FirebaseKey.uid) as? String
        birthDate = aDecoder.decodeObject(forKey: FirebaseKey.birthDate) as? Date
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey: FirebaseKey.userName)
        aCoder.encode(password, forKey: FirebaseKey.password)
        aCoder.encode(email, forKey: FirebaseKey.email)
        aCoder.encode(avatarLink, forKey: FirebaseKey.avatarLink)
        aCoder.encode(uid, forKey: FirebaseKey.uid)
        aCoder.encode(birthDate, forKey: FirebaseKey.birthDate)
    }
    
    override init() {}
    
    fileprivate init(with dictionry: [String: Any])
    {
        self.userName = dictionry[FirebaseKey.userName] as! String?
        self.email = dictionry[FirebaseKey.email] as! String?
        self.password = dictionry[FirebaseKey.password] as! String?
        self.avatarLink = dictionry[FirebaseKey.avatarLink] as! String?
        self.uid = dictionry[FirebaseKey.uid] as! String?
        
        guard let cteatedUNIXDate = dictionry[FirebaseKey.birthDate] as? Double else { return }
        self.birthDate = Date(timeIntervalSince1970: TimeInterval(cteatedUNIXDate))
    }
}

