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
    
    var needsAds = true
    var congratulations = true
    var push = true
    var localNotifications = true
    
    init?(json: JSON) {
        guard let needsAds = json[FirebaseKey.needsAds].bool,
            let congratulations = json[FirebaseKey.congratulations].bool,
            let push = json[FirebaseKey.push].bool,
            let localNotifications = json[FirebaseKey.localNotifications].bool else { return nil }
        
        self.needsAds = needsAds
        self.congratulations = congratulations
        self.push = push
        self.localNotifications = localNotifications
    }
    
    required init?(coder aDecoder: NSCoder) {
        needsAds = aDecoder.decodeBool(forKey: FirebaseKey.needsAds)
        congratulations = aDecoder.decodeBool(forKey: FirebaseKey.congratulations)
        push = aDecoder.decodeBool(forKey: FirebaseKey.push)
        localNotifications = aDecoder.decodeBool(forKey: FirebaseKey.localNotifications)
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(needsAds, forKey: FirebaseKey.needsAds)
        aCoder.encode(congratulations, forKey: FirebaseKey.congratulations)
        aCoder.encode(push, forKey: FirebaseKey.push)
        aCoder.encode(localNotifications, forKey: FirebaseKey.localNotifications)
    }
    
}
