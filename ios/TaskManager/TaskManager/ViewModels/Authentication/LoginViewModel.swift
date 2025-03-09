//
//  LoginViewModel.swift
//  TaskManager
//
//  Created by Abhishek G on 07/03/25.
//

import SwiftUI

/// ViewModel for the LoginView handling the business logic for user authentication
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// User's email input
    @Published var email = ""
    
    /// User's password input
    @Published var password = ""
    
    /// Error message for email validation
    @Published var emailErrorMessage = ""
    
    /// Error message for password validation
    @Published var passwordErrorMessage = ""
    
    /// Loading state indicator
    @Published var isLoading = false
    
    /// Alert visibility control
    @Published var showAlert = false
    
    /// Alert message content
    @Published var alertMessage = ""
    
    // MARK: - Private Properties
    
    /// Authentication service to handle user login
    private let authService: AuthService
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with an authentication service
    /// - Parameter authService: The service responsible for authentication operations
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    
    /// Handles the login process including validation and API call
    func login() {
        validateForm()
        guard emailErrorMessage.isEmpty && passwordErrorMessage.isEmpty else { return }
        
        isLoading = true
        authService.signIn(email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.alertMessage = self?.authService.errorMessage ?? "Invalid email or password"
                    self?.showAlert = true
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Validates all form fields and sets appropriate error messages
    private func validateForm() {
        emailErrorMessage = Validation.isFieldEmpty(email) ? "Email is required" : ""
        passwordErrorMessage = Validation.isFieldEmpty(password) ? "Password is required" : ""
    }
}
