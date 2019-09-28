//
//  NetworkManager.swift
//  TvOnTheGo
//
//  Created by Sujata Chakraborty on 03/08/2017.
//  Copyright © 2017 Sujata Chakraborty. All rights reserved.
//

import Foundation


public final class NetworkManager{
    
    var internetReachability : Reachability?
    
    public var isInternetAccessible = false
    public var isWifi = false
    public var isEthernet = false
    // Can't init is singleton
    private init() {
        
    }
    
    //MARK: Shared Instance
    
   public static let sharedInstance: NetworkManager = NetworkManager()
    
   public func startReachabilityMonitoring()
    {
        
        internetReachability = Reachability()!
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: internetReachability)
        
        do{
            try internetReachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        updateNetworkStatus(reachability: internetReachability!)
        
    }
    
    public func updateNetworkStatus(reachability : Reachability)
    {
        let reachStatus  = reachability.connection
        switch reachStatus {
        case .none:
               isInternetAccessible = false
                isWifi = false
                isEthernet = false
                break
        default:
            isInternetAccessible = true
            isWifi = isConnectedByWiFi()
            isEthernet = isConnectedByEthernet()
        }
        
    }
    
    @objc func reachabilityChanged(note : NSNotification)
    {
        let curReach = note.object as? Reachability
        if curReach != nil
        {
            internetReachability = curReach!
            self.updateNetworkStatus(reachability: curReach!)
        }
    }
    
    public func refreshConnectionState() {
        if(internetReachability == nil){
            internetReachability = Reachability()!
            self.updateNetworkStatus(reachability: internetReachability!)
        }
    }
    
    public func conenctionType() -> String{
        if  (isWifi){
            return "WiFi"
        }
        else if (isEthernet){
            return "LAN"
        }
        else {
            return "Unknown"
        }
    }
    
    public class var carrierName: String? {
        
        return ""
    }
    
    public func getConenctionType() -> Bool {
        if (isConnectedByEthernet()){
            return true
        }
        if(isConnectedByWiFi()){
            return true
        }
        return false
    }
    
    // Code to go through the interfaces to determine wired or wireless connection being used
    public func getInterfaces() -> [(name : String, addr: String, mac : String)] {
        
        var addresses = [(name : String, addr: String, mac : String)]()
        var nameToMac = [ String: String ]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            if var addr = ptr.pointee.ifa_addr {
                let name = String(cString: ptr.pointee.ifa_name)
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    switch Int32(addr.pointee.sa_family) {
                    case AF_LINK:
                        nameToMac[name] = withUnsafePointer(to: &addr) { unsafeAddr in
                            unsafeAddr.withMemoryRebound(to: sockaddr_dl.self, capacity: 1) { dl in
                                dl.withMemoryRebound(to: Int8.self, capacity: 1) { dll in
                                    let lladdr = UnsafeRawBufferPointer(start: dll + 8 + Int(dl.pointee.sdl_nlen), count: Int(dl.pointee.sdl_alen))
                                    
                                    if lladdr.count == 6 {
                                        return lladdr.map { String(format:"%02hhx", $0)}.joined(separator: ":")
                                    } else {
                                        return nil
                                    }
                                }
                            }
                        }
                        
                    case AF_INET, AF_INET6:
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(addr, socklen_t(addr.pointee.sa_len),
                                        &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            let address = String(cString: hostname)
                            addresses.append( (name: name, addr: address, mac : "") )
                        }
                    default:
                        break
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        
        // Now add the mac address to the tuples:
        for (i, addr) in addresses.enumerated() {
            if let mac = nameToMac[addr.name] {
                addresses[i] = (name: addr.name, addr: addr.addr, mac : mac)
            }
        }
        return addresses
    }
    
    public func isConnectedByEthernet() -> Bool{
        for addr in getInterfaces() {
            if addr.name == NetworkInterfaceType.Ethernet.rawValue {
                return true
            }
        }
        return false
    }
    
    public func isConnectedByWiFi() -> Bool{
        for addr in getInterfaces() {
            if addr.name == NetworkInterfaceType.Wifi.rawValue {
                return true
            }
        }
        return false
    }
    enum NetworkInterfaceType: String, CustomStringConvertible {
        case Ethernet = "en0"
        case Wifi = "en1"
        case Unknown = ""
        
        var description: String {
            switch self {
            case .Ethernet:
                return "Ethernet"
            case .Wifi:
                return "Wifi"
            case .Unknown:
                return "Unknown"
            }
        }
    }
}
