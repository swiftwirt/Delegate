//
//  UserService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DLGUser: NSObject, NSCoding {
    
    var firstName: String? = nil
    var lastName: String? = nil
    var birthDate: Date? = nil
    var email: String? = nil
    var password: String? = nil
    var avatarLink: String? = nil
    var uid: String? = nil
    
    var vipPlanExpirationDate: Date? = nil
    
    required init?(coder aDecoder: NSCoder) {
        firstName = aDecoder.decodeObject(forKey: FirebaseKey.firstName) as? String
        lastName = aDecoder.decodeObject(forKey: FirebaseKey.lastName) as? String
        email = aDecoder.decodeObject(forKey: FirebaseKey.email) as? String
        password = aDecoder.decodeObject(forKey: FirebaseKey.password) as? String
        avatarLink = aDecoder.decodeObject(forKey: FirebaseKey.avatarLink) as? String
        uid = aDecoder.decodeObject(forKey: FirebaseKey.uid) as? String
        birthDate = aDecoder.decodeObject(forKey: FirebaseKey.birthDate) as? Date
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: FirebaseKey.firstName)
        aCoder.encode(firstName, forKey: FirebaseKey.lastName)
        aCoder.encode(password, forKey: FirebaseKey.password)
        aCoder.encode(email, forKey: FirebaseKey.email)
        aCoder.encode(avatarLink, forKey: FirebaseKey.avatarLink)
        aCoder.encode(uid, forKey: FirebaseKey.uid)
        aCoder.encode(birthDate, forKey: FirebaseKey.birthDate)
    }
    
    override init() {}
    
    fileprivate init(with dictionry: [String: Any])
    {
        self.firstName = dictionry[FirebaseKey.firstName] as! String?
        self.lastName = dictionry[FirebaseKey.lastName] as! String?
        self.email = dictionry[FirebaseKey.email] as! String?
        self.password = dictionry[FirebaseKey.password] as! String?
        self.avatarLink = dictionry[FirebaseKey.avatarLink] as! String?
        self.uid = dictionry[FirebaseKey.uid] as! String?
        
        guard let cteatedUNIXDate = dictionry[FirebaseKey.birthDate] as? Double else { return }
        self.birthDate = Date(timeIntervalSince1970: TimeInterval(cteatedUNIXDate))
    }
    
    fileprivate init?(with snapShoot: DataSnapshot)
    {
        guard let snap = snapShoot.value as? [String: Any] else { return nil }
        self.firstName = snap[FirebaseKey.firstName] as! String?
        self.lastName = snap[FirebaseKey.lastName] as! String?
        self.email = snap[FirebaseKey.email] as! String?
        self.password = snap[FirebaseKey.password] as! String?
        self.avatarLink = snap[FirebaseKey.avatarLink] as! String?
        self.uid = snapShoot.key
        
        guard let cteatedUNIXDate = snap[FirebaseKey.birthDate] as? Double else { return nil }
        self.birthDate = Date(timeIntervalSince1970: TimeInterval(cteatedUNIXDate))
    }
    
}

class UserService: NSObject {
    
    enum CodingKeys {
        static let user = "User"
        static let plist = "Delegate.plist"
    }
    
    fileprivate(set) var user: DLGUser? = nil
    fileprivate let dateFormatter = Formatters.dateFormatter
    
    func createNewUser()
    {
        user = DLGUser()
    }
    
    func crateNewCurrentUser(with dictionary: [String: Any])
    {
        user = DLGUser(with: dictionary)
    }
    
    func getDelegateUser(from JSON: [String: Any]) -> DLGUser
    {
        return DLGUser(with: JSON)
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
        data.write(toFile: dataFilePath, atomically: true)
    }
    
    func loadUser()
    {
        if FileManager.default.fileExists(atPath: dataFilePath), let data = try? Data(contentsOf: URL(fileURLWithPath: dataFilePath)) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            user = unarchiver.decodeObject(forKey: CodingKeys.user) as? DLGUser
            unarchiver.finishDecoding()
        }
    }
    
    fileprivate var documentsDirectory: String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    fileprivate var dataFilePath: String
    {
        return (documentsDirectory as NSString).appendingPathComponent(CodingKeys.plist)
    }
    
}

