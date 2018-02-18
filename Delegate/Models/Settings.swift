//
//  Settings.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Settings: NSCoder {
    
    var needsAds: Bool? = nil
    var congratulations: Bool? = nil
    var push: Bool? = nil
    var localNotifications: Bool? = nil
    
    init(json: JSON) {
        guard let needsAds = json[FirebaseKey.needsAds.rawValue].bool,
            let congratulations = json[FirebaseKey.congratulations.rawValue].bool,
            let push = json[FirebaseKey.push.rawValue].bool,
            let localNotifications = json[FirebaseKey.localNotifications.rawValue].bool else {
                self.needsAds = true
                self.congratulations = true
                self.push = true
                self.localNotifications = true
                return
        }
        
        self.needsAds = needsAds
        self.congratulations = congratulations
        self.push = push
        self.localNotifications = localNotifications
    }
    
    required init?(coder aDecoder: NSCoder) {
        needsAds = aDecoder.decodeBool(forKey: FirebaseKey.needsAds.rawValue)
        congratulations = aDecoder.decodeBool(forKey: FirebaseKey.congratulations.rawValue)
        push = aDecoder.decodeBool(forKey: FirebaseKey.push.rawValue)
        localNotifications = aDecoder.decodeBool(forKey: FirebaseKey.localNotifications.rawValue)
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        if let needsAds = needsAds {
            aCoder.encode(needsAds, forKey: FirebaseKey.needsAds.rawValue)
        }
        
        if let congratulations = congratulations {
            aCoder.encode(congratulations, forKey: FirebaseKey.congratulations.rawValue)
        }
        
        if let push = push {
            aCoder.encode(push, forKey: FirebaseKey.push.rawValue)
        }
        
        if let localNotifications = localNotifications {
            aCoder.encode(localNotifications, forKey: FirebaseKey.localNotifications.rawValue)
        }
    }
    
}
