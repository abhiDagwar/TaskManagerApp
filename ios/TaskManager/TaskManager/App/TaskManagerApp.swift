//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI
import Firebase

/// Main application entry point
@main
struct TaskManagerApp: App {
    // MARK: - Properties
    
    /// Firebase delegate for initialization
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) var appDelegate

    /// Shared authentication service instance
    @StateObject private var authService = AuthService.shared
    
    @StateObject private var viewModel = TaskViewModel()

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService) // ⚠️ Critical Fix Here
                .environmentObject(viewModel)
        }
    }
}
