//
//  ContentView.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI

/// Main content view that handles authentication state and navigates to appropriate views
struct ContentView: View {
    // MARK: - Properties
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack { // Root navigation stack
            Group {
                if authService.isAuthenticated {
                    //TaskListView()
                    // In the future, this will show the task list when implemented
                    Text("Welcome! You are logged in.")
                        .font(.title)
                        .padding()
                    
                    Button("Sign Out") {
                        viewModel.signOut()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                } else {
                    LoginView()
                }
            }
            .transition(.opacity) // Optional animation
        }
        .environmentObject(AuthService.shared) // Required
    }
}

#Preview {
    ContentView()
}
