//
//  UserService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON

class DLGUser: NSObject, NSCoding {
    
    var naviteUser: Bool = false // used to detect user registration with socials
    var userName: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var birthDate: Date? = nil
    var email: String? = nil
    var password: String? = nil
    var avatarLink: String? = nil
    var uid: String? = nil
    var settings: Settings? = nil
    
    required init?(coder aDecoder: NSCoder)
    {
        naviteUser = aDecoder.decodeBool(forKey: FirebaseKey.naviteUser.rawValue)
        userName = aDecoder.decodeObject(forKey: FirebaseKey.userName.rawValue) as? String
        firstName = aDecoder.decodeObject(forKey: FirebaseKey.firstName.rawValue) as? String
        lastName = aDecoder.decodeObject(forKey: FirebaseKey.lastName.rawValue) as? String
        email = aDecoder.decodeObject(forKey: FirebaseKey.email.rawValue) as? String
        password = aDecoder.decodeObject(forKey: FirebaseKey.password.rawValue) as? String
        avatarLink = aDecoder.decodeObject(forKey: FirebaseKey.avatarLink.rawValue) as? String
        uid = aDecoder.decodeObject(forKey: FirebaseKey.uid.rawValue) as? String
        birthDate = aDecoder.decodeObject(forKey: FirebaseKey.birthDate.rawValue) as? Date
        settings = aDecoder.decodeObject(forKey: FirebaseKey.settings.rawValue) as? Settings
        super.init()
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(naviteUser, forKey: FirebaseKey.naviteUser.rawValue)
        
        if let userName = userName {
            aCoder.encode(userName, forKey: FirebaseKey.userName.rawValue)
        }
        
        if let firstName = firstName {
            aCoder.encode(firstName, forKey: FirebaseKey.firstName.rawValue)
        }
        
        if let lastName = lastName {
            aCoder.encode(lastName, forKey: FirebaseKey.lastName.rawValue)
        }
        
        if let password = password {
            aCoder.encode(password, forKey: FirebaseKey.password.rawValue)
        }
        
        if let email = email {
            aCoder.encode(email, forKey: FirebaseKey.email.rawValue)
        }
        
        if let avatarLink = avatarLink {
            aCoder.encode(avatarLink, forKey: FirebaseKey.avatarLink.rawValue)
        }
        
        if let uid = uid {
            aCoder.encode(uid, forKey: FirebaseKey.uid.rawValue)
        }
        
        if let birthDate = birthDate {
            aCoder.encode(birthDate, forKey: FirebaseKey.birthDate.rawValue)
        }
        
        if let settings = settings {
            aCoder.encode(settings, forKey: FirebaseKey.settings.rawValue)
        }

    }
    
    override init() {}
    
    init(with json: JSON)
    {
        self.naviteUser = json[FirebaseKey.naviteUser.rawValue].bool ?? false
        self.userName = json[FirebaseKey.userName.rawValue].string
        self.firstName = json[FirebaseKey.firstName.rawValue].string
        self.lastName = json[FirebaseKey.lastName.rawValue].string
        self.email = json[FirebaseKey.email.rawValue].string
        self.password = json[FirebaseKey.password.rawValue].string
        self.avatarLink = json[FirebaseKey.avatarLink.rawValue].string
        self.uid = json[FirebaseKey.uid.rawValue].string
        self.settings = Settings(json: json[FirebaseKey.settings.rawValue])
        
        guard let cteatedUNIXDate = json[FirebaseKey.birthDate.rawValue].double else { return }
        self.birthDate = Date(timeIntervalSince1970: TimeInterval(cteatedUNIXDate))
    }
    
    init?(with snapShoot: DataSnapshot)
    {
        guard let snap = snapShoot.value as? [String: Any] else { return nil }
        self.naviteUser = snap[FirebaseKey.naviteUser.rawValue] as! Bool? ?? false
        self.userName = snap[FirebaseKey.userName.rawValue] as! String?
        self.firstName = snap[FirebaseKey.firstName.rawValue] as! String?
        self.lastName = snap[FirebaseKey.lastName.rawValue] as! String?
        self.email = snap[FirebaseKey.email.rawValue] as! String?
        self.password = snap[FirebaseKey.password.rawValue] as! String?
        self.avatarLink = snap[FirebaseKey.avatarLink.rawValue] as! String?
        self.uid = snapShoot.key
        
        if let settingsJSON = snap[FirebaseKey.settings.rawValue] as? JSON {
            self.settings = Settings(json: settingsJSON)
        }
        
        guard let cteatedUNIXDate = snap[FirebaseKey.birthDate.rawValue] as? Double else { return nil }
        self.birthDate = Date(timeIntervalSince1970: TimeInterval(cteatedUNIXDate))
    }
    
}

class UserService: NSObject {
    
    enum CodingKeys {
        static let user = "User"
        static let plist = "Delegate.plist"
    }
    
    var user: DLGUser? = nil
    fileprivate let dateFormatter = Formatters.dateFormatter
    
    func createNewUser()
    {
        user = DLGUser()
    }
    
    func crateNewCurrentUser(with json: JSON)
    {
        user = DLGUser(with: json)
    }
    
    func getDelegateUser(from snapShoot: DataSnapshot) -> DLGUser?
    {
        return DLGUser(with: snapShoot)
    }
    
    var fullName: String? {
        
        if let firstName = user?.firstName, let lastName = user?.lastName {
            return firstName + " " + lastName
        } else if let firstName = user?.firstName {
            return firstName
        }  else if let lastName = user?.lastName {
            return lastName
        } else {
            return nil
        }
        
    }
    
    var email: String? {
        if let email = user?.email {
            return email
        } else if let email = Auth.auth().currentUser?.email {
            return email
        } else {
            return nil
        }
    }
    
    var needsRestoration: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.needsRestoration)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.needsRestoration)
            UserDefaults.standard.synchronize()
        }
    }
    
    var previouslyLaunched: Bool {
        get {
            let previouslyLaunched = UserDefaults.standard.bool(forKey: Constants.previouslyLaunched)
            if !previouslyLaunched {
                UserDefaults.standard.set(true, forKey: Constants.previouslyLaunched)
                UserDefaults.standard.synchronize()
            }
            return previouslyLaunched
        }
    }
    
    func convertToDefaultFormat(date: Date) -> String?
    {
        Formatters.dateFormatter.dateFormat = "dd. MMMM YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getFormattedBirthDate() -> String?
    {
        guard user?.birthDate != nil else { return nil }
        dateFormatter.dateFormat = "dd. MMMM YYYY"
        return dateFormatter.string(from: user!.birthDate!)
    }
    
    // Serialization
    
    func saveUser()
    {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(user, forKey: CodingKeys.user)
        archiver.finishEncoding()
        data.write(toFile: UserService.dataFilePath, atomically: true)
    }
    
    func loadUser()
    {
        if FileManager.default.fileExists(atPath: UserService.dataFilePath), let data = try? Data(contentsOf: URL(fileURLWithPath: UserService.dataFilePath)) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            user = unarchiver.decodeObject(forKey: CodingKeys.user) as? DLGUser
            unarchiver.finishDecoding()
        }
    }
    
    static var documentsDirectory: String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static var dataFilePath: String
    {
        return (UserService.documentsDirectory as NSString).appendingPathComponent(CodingKeys.plist)
    }
}

