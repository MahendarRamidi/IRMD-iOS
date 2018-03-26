//
//  Reachability.swift
//  Sesame
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import Foundation
import SystemConfiguration

let ReachabilityChangedNotification = "ReachabilityChangedNotification"

class Reachability: NSObject {
    
    typealias NetworkReachable = (Reachability) -> ()
    typealias NetworkUneachable = (Reachability) -> ()
    
    enum NetworkStatus: CustomStringConvertible {
        
        case notReachable, reachableViaWiFi, reachableViaWWAN
        
        var description: String {
            switch self {
            case .reachableViaWWAN:
                return "Cellular"
            case .reachableViaWiFi:
                return "WiFi"
            case .notReachable:
                return "No Connection"
            }
        }
    }
    
    // MARK: - *** Public properties ***
    
    var whenReachable: NetworkReachable?
    var whenUnreachable: NetworkUneachable?
    var reachableOnWWAN: Bool
    
    var currentReachabilityStatus: NetworkStatus {
        if isReachable() {
            if isReachableViaWiFi() {
                return .reachableViaWiFi
            }
            if isRunningOnDevice {
                return .reachableViaWWAN;
            }
        }
        
        return .notReachable
    }
    
    var currentReachabilityString: String {
        return "\(currentReachabilityStatus)"
    }
    
    // MARK: - *** Initialisation methods ***
    convenience init(hostname: String) {
        let ref = SCNetworkReachabilityCreateWithName(nil, (hostname as NSString).utf8String!)
        self.init(reachabilityRef: ref!)
    }
    
    class func reachabilityForInternetConnection() -> Reachability {
        
        var zeroAddress = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let ref = withUnsafePointer(to: &zeroAddress) {
            //SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, zeroSockAddress)
            }
            
        }
        return Reachability(reachabilityRef: ref!)
    }
    
    class func reachabilityForLocalWiFi() -> Reachability {
        
        var localWifiAddress: sockaddr_in = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        localWifiAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
        localWifiAddress.sin_addr.s_addr = in_addr_t(UInt64(0xA9FE0000 as uint).bigEndian)
        
        let ref = withUnsafePointer(to: &localWifiAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        return Reachability(reachabilityRef: ref!)
    }
    
    // MARK: - *** Notifier methods ***
    func startNotifier() -> Bool {
        
        reachabilityObject = self
        let reachability = self.reachabilityRef!
        
        previousReachabilityFlags = reachabilityFlags;
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Reachability.timerFired(_:)), userInfo: nil, repeats: true)
        
        return true;
    }
    
    func stopNotifier() {
        
        reachabilityObject = nil;
        
        timer?.invalidate()
        timer = nil;
    }
    
    // MARK: - *** Connection test methods ***
    func isReachable() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isReachableWithFlags(flags)
        })
    }
    
    func isReachableViaWWAN() -> Bool {
        
        if isRunningOnDevice {
            return isReachableWithTest() { flags -> Bool in
                // Check we're REACHABLE
                if self.isReachable(flags) {
                    
                    // Now, check we're on WWAN
                    if self.isOnWWAN(flags) {
                        return true
                    }
                }
                return false
            }
        }
        return false
    }
    
    func isReachableViaWiFi() -> Bool {
        
        return isReachableWithTest() { flags -> Bool in
            
            // Check we're reachable
            if self.isReachable(flags) {
                
                if self.isRunningOnDevice {
                    // Check we're NOT on WWAN
                    if self.isOnWWAN(flags) {
                        return false
                    }
                }
                return true
            }
            
            return false
        }
    }
    
    // MARK: - *** Private methods ***
    private var isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }()
    
    private var reachabilityRef: SCNetworkReachability?
    private var reachabilityObject: AnyObject?
    private var timer: Timer?
    private var previousReachabilityFlags: SCNetworkReachabilityFlags?
    
    private init(reachabilityRef: SCNetworkReachability) {
        reachableOnWWAN = true;
        self.reachabilityRef = reachabilityRef;
    }
    
    func timerFired(_ timer: Timer) {
        
        let currentReachabilityFlags = reachabilityFlags
        if let _previousReachabilityFlags = previousReachabilityFlags {
            if currentReachabilityFlags != previousReachabilityFlags {
                reachabilityChanged(currentReachabilityFlags)
                previousReachabilityFlags = currentReachabilityFlags
            }
        }
    }
    
    private func reachabilityChanged(_ flags: SCNetworkReachabilityFlags) {
        if isReachableWithFlags(flags) {
            if let block = whenReachable {
                block(self)
            }
        } else {
            if let block = whenUnreachable {
                block(self)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object:self)
        
    }
    
    private func isReachableWithFlags(_ flags: SCNetworkReachabilityFlags) -> Bool {
        
        let reachable = isReachable(flags)
        
        if !reachable {
            return false
        }
        
        if isConnectionRequiredOrTransient(flags) {
            return false
        }
        
        if isRunningOnDevice {
            if isOnWWAN(flags) && !reachableOnWWAN {
                // We don't want to connect when on 3G.
                return false
            }
        }
        
        return true
    }
    
    private func isReachableWithTest(_ test: (SCNetworkReachabilityFlags) -> (Bool)) -> Bool {
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue:0)
        let gotFlags = SCNetworkReachabilityGetFlags(reachabilityRef!, &flags).hashValue != 0
        if gotFlags {
            return test(flags)
        }
        
        return false
    }
    
    // WWAN may be available, but not active until a connection has been established.
    // WiFi may require a connection for VPN on Demand.
    private func isConnectionRequired() -> Bool {
        return connectionRequired()
    }
    
    private func connectionRequired() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags)
        })
    }
    
    // Dynamic, on demand connection?
    private func isConnectionOnDemand() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags) && self.isConnectionOnTrafficOrDemand(flags)
        })
    }
    
    // Is user intervention required?
    private func isInterventionRequired() -> Bool {
        return isReachableWithTest({ (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags) && self.isInterventionRequired(flags)
        })
    }
    
    private func isOnWWAN(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.isWWAN.rawValue != 0
    }
    private func isReachable(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.reachable.rawValue != 0
    }
    private func isConnectionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.connectionRequired.rawValue != 0
    }
    private func isInterventionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.interventionRequired.rawValue != 0
    }
    private func isConnectionOnTraffic(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.connectionOnTraffic.rawValue != 0
    }
    private func isConnectionOnDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.connectionOnDemand.rawValue != 0
    }
    func isConnectionOnTrafficOrDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & (SCNetworkReachabilityFlags.connectionOnTraffic.rawValue | SCNetworkReachabilityFlags.connectionOnDemand.rawValue) != 0
    }
    private func isTransientConnection(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.transientConnection.rawValue != 0
    }
    private func isLocalAddress(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.isLocalAddress.rawValue != 0
    }
    private func isDirect(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.rawValue & SCNetworkReachabilityFlags.isDirect.rawValue != 0
    }
    private func isConnectionRequiredOrTransient(_ flags: SCNetworkReachabilityFlags) -> Bool {
        let testcase = (SCNetworkReachabilityFlags.connectionRequired.rawValue | SCNetworkReachabilityFlags.transientConnection.rawValue)
        return flags.rawValue & testcase == testcase
    }
    
    private var reachabilityFlags: SCNetworkReachabilityFlags {
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue:0)
        let gotFlags = SCNetworkReachabilityGetFlags(reachabilityRef!, &flags).hashValue != 0
        if gotFlags {
            return flags
        }
        
        return SCNetworkReachabilityFlags(rawValue:0)
    }
    
    override var description: String {
        
        var W: String
        if isRunningOnDevice {
            W = isOnWWAN(reachabilityFlags) ? "W" : "-"
        } else {
            W = "X"
        }
        let R = isReachable(reachabilityFlags) ? "R" : "-"
        let c = isConnectionRequired(reachabilityFlags) ? "c" : "-"
        let t = isTransientConnection(reachabilityFlags) ? "t" : "-"
        let i = isInterventionRequired(reachabilityFlags) ? "i" : "-"
        let C = isConnectionOnTraffic(reachabilityFlags) ? "C" : "-"
        let D = isConnectionOnDemand(reachabilityFlags) ? "D" : "-"
        let l = isLocalAddress(reachabilityFlags) ? "l" : "-"
        let d = isDirect(reachabilityFlags) ? "d" : "-"
        
        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
    
    deinit {
        stopNotifier()
        
        reachabilityRef = nil
        whenReachable = nil
        whenUnreachable = nil
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags).hashValue == 0 {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(SCNetworkReachabilityFlags.reachable.rawValue)) != 0
        let needsConnection = (flags.rawValue & UInt32(SCNetworkReachabilityFlags.connectionRequired.rawValue)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
}
