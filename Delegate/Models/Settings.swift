//
//  Settings.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/13/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Settings: NSObject, NSCoding {
    
    var needsAds = true
    var congratulations = true
    var push = true
    var localNotifications = true
    
    override init() {
        super.init()
    }
    
    init?(json: JSON) {
        guard let needsAds = json[FirebaseKey.needsAds.rawValue].bool,
            let congratulations = json[FirebaseKey.congratulations.rawValue].bool,
            let push = json[FirebaseKey.push.rawValue].bool,
            let localNotifications = json[FirebaseKey.localNotifications.rawValue].bool else {
                return nil
        }
        
        self.needsAds = needsAds
        self.congratulations = congratulations
        self.push = push
        self.localNotifications = localNotifications
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        needsAds = aDecoder.decodeBool(forKey: FirebaseKey.needsAds.rawValue)
        congratulations = aDecoder.decodeBool(forKey: FirebaseKey.congratulations.rawValue)
        push = aDecoder.decodeBool(forKey: FirebaseKey.push.rawValue)
        localNotifications = aDecoder.decodeBool(forKey: FirebaseKey.localNotifications.rawValue)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(needsAds, forKey: FirebaseKey.needsAds.rawValue)
        
        aCoder.encode(congratulations, forKey: FirebaseKey.congratulations.rawValue)
        
        aCoder.encode(push, forKey: FirebaseKey.push.rawValue)
        
        aCoder.encode(localNotifications, forKey: FirebaseKey.localNotifications.rawValue)
    }
    
}
