//
//  ReachabilityService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/3/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import RxSwift
import CoreTelephony

enum ReachabilityStatus {
    case notReachable
    case reachableViaWifi
    case reachableViaCell2G
    case reachableViaCell3G
    case reachableViaCell4G
}

class ReachabilityService {
    
    enum RadioAccessTechnologyType {
        case secondGeneration
        case thirdGeneration
        case fourthGeneration
    }
    
    enum RadioAccessTechnology: String {
        
        case cdma = "CTRadioAccessTechnologyCDMA1x"
        case edge = "CTRadioAccessTechnologyEdge"
        case gprs = "CTRadioAccessTechnologyGPRS"
        case hrpd = "CTRadioAccessTechnologyeHRPD"
        case hsdpa = "CTRadioAccessTechnologyHSDPA"
        case hsupa = "CTRadioAccessTechnologyHSUPA"
        case lte = "CTRadioAccessTechnologyLTE"
        case rev0 = "CTRadioAccessTechnologyCDMAEVDORev0"
        case revA = "CTRadioAccessTechnologyCDMAEVDORevA"
        case revB = "CTRadioAccessTechnologyCDMAEVDORevB"
        case wcdma = "CTRadioAccessTechnologyWCDMA"
        
        var radioAccessTechnologyType: RadioAccessTechnologyType {
            switch self {
            case .gprs, .edge, .cdma:
                return .secondGeneration
            case .lte:
                return .fourthGeneration
            default:
                return .thirdGeneration
            }
        }
    }
    
    fileprivate let subject = PublishSubject<ReachabilityStatus>()
    
    fileprivate let reachability = Reachability()!
    
    fileprivate var reachabilityStatus = ReachabilityStatus.notReachable {
        didSet {
            subject.onNext(reachabilityStatus)
        }
    }
    
    var observableReachabilityStatus: Observable<ReachabilityStatus> {
        return subject
    }
    
    func configureReachability()
    {
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    self.reachabilityStatus = .reachableViaWifi
                } else if reachability.isReachableViaWWAN {
                    
                    let networkInfo = CTTelephonyNetworkInfo()
                    if let networkString = networkInfo.currentRadioAccessTechnology, let tecnology = RadioAccessTechnology(rawValue: networkString) {
                        switch tecnology.radioAccessTechnologyType {
                        case .secondGeneration:
                            self.reachabilityStatus = .reachableViaCell2G
                        case .thirdGeneration:
                            self.reachabilityStatus = .reachableViaCell3G
                        case .fourthGeneration:
                            self.reachabilityStatus = .reachableViaCell4G
                        }
                    }
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.reachabilityStatus = .notReachable
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            self.reachabilityStatus = .reachableViaWifi
            self.subject.onNext(self.reachabilityStatus)
        }
    }
    
}
