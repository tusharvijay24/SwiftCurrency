//
//  NetworkLayer.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let reachabilityManager = NetworkReachabilityManager()
    private init() {
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular connection")
            }
        })
    }
    
    var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    var isReachableOnCellular: Bool {
        return reachabilityManager?.isReachableOnCellular ?? false
    }
    
    var isReachableOnWiFi: Bool {
        return reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
}
