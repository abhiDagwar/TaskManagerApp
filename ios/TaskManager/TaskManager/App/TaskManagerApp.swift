//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        // Initialize AuthService and inject it globally
        let authService = AuthService.shared
        WindowGroup {
            ContentView()
                .environmentObject(authService) // ⚠️ Critical Fix Here
        }
    }
}
