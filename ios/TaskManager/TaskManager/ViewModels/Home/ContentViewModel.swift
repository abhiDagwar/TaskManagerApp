//
//  ContentViewModel.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI

/// ViewModel for the ContentView handling the app's main navigation state
class ContentViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Authentication service to handle user authentication status
    private let authService: AuthService
    
    /// Published property that reflects the current authentication status
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with an authentication service
    /// - Parameter authService: The service responsible for authentication operations
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
        
        // Set initial authentication state
        self.isAuthenticated = authService.isAuthenticated
        
        // Subscribe to authentication state changes
        setupAuthObserver()
    }
    
    // MARK: - Private Methods
    
    /// Sets up an observer for authentication state changes
    private func setupAuthObserver() {
        // This would typically use Combine to subscribe to authService changes
        // For simplicity, we're relying on the @EnvironmentObject in the View
    }
    
    // MARK: - Public Methods
    
    /// Signs out the current user
    func signOut() {
        authService.signOut()
    }
}

