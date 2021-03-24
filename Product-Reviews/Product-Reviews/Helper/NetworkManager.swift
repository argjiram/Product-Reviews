 //
 //  ImageExtension.swift
 //  Product-Reviews
 //
 //  Created by Argjira Mala on 3/23/21.
 //

import Foundation
import SystemConfiguration
import Reachability

class NetworkManager: NSObject {

    var reachability : Reachability!

    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()


    override init() {
        super.init()

        // Initialise reachability
        reachability = try! Reachability()

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }

    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    // Network is reachable
    static func isReachableAll(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isReachable() -> Bool {
          if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
              //completed(NetworkManager.sharedInstance)
            return true
          }
        return false
      }

    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .unavailable {
            completed(NetworkManager.sharedInstance)
        }
    }

    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }

    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}
