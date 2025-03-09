//
//  FirebaseAppDelegate.swift
//  TaskManager
//
//  Created by Abhishek G on 24/02/25.
//

import UIKit
import Firebase

/// UIApplicationDelegate to set up Firebase when the app launches
class FirebaseAppDelegate: NSObject, UIApplicationDelegate {
    // MARK: - UIApplicationDelegate Methods
    
    /// Called when the app finishes launching
    /// - Parameters:
    ///   - application: The app instance
    ///   - launchOptions: Dictionary of launch options
    /// - Returns: Success indicator for app launch
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Configure Firebase when the app starts
        FirebaseApp.configure()
        
        return true
    }
}
