//
//  SignupViewModel.swift
//  TaskManager
//
//  Created by Abhishek G on 09/03/25.
//

import SwiftUI

/// ViewModel for the SignupView handling the business logic for user signup
class SignupViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// User's email input
    @Published var email = ""
    
    /// User's password input
    @Published var password = ""
    
    /// Re-entered password for confirmation
    @Published var reEnterPassword = ""
    
    /// Error message for email validation
    @Published var emailErrorMessage = ""
    
    /// Error message for password validation
    @Published var passwordErrorMessage = ""
    
    /// Error message for password confirmation
    @Published var reEnterPasswordErrorMessage = ""
    
    /// Loading state indicator
    @Published var isLoading = false
    
    /// Alert visibility control
    @Published var showAlert = false
    
    /// Alert title
    @Published var alertTitle = ""
    
    /// Alert message content
    @Published var alertMessage = ""
    
    /// Flag to indicate successful signup
    @Published var isSignupSuccessful = false
    
    // MARK: - Private Properties
    
    /// Authentication service to handle user registration
    private let authService: AuthService
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with an authentication service
    /// - Parameter authService: The service responsible for authentication operations
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    
    /// Handles the signup process including validation and API call
    func handleSignup() {
        validateForm()
        guard emailErrorMessage.isEmpty,
              passwordErrorMessage.isEmpty,
              reEnterPasswordErrorMessage.isEmpty
        else { return }
        
        isLoading = true
        authService.signUp(email: email, password: password) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            if success {
                self.alertTitle = "Success!"
                self.alertMessage = "Account created successfully."
                self.isSignupSuccessful = true
                self.showAlert = true
            } else {
                self.alertTitle = "Signup Failed"
                self.alertMessage = self.authService.errorMessage ?? "Unknown error"
                self.showAlert = true
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Validates all form fields and sets appropriate error messages
    private func validateForm() {
        if Validation.isFieldEmpty(email) {
            emailErrorMessage = "Email is required"
        } else if !Validation.isValidEmail(email) {
            emailErrorMessage = "Invalid email format"
        } else {
            emailErrorMessage = ""
        }
        
        if Validation.isFieldEmpty(password) {
            passwordErrorMessage = "Password is required"
        } else if !Validation.isValidPassword(password) {
            passwordErrorMessage = "Password must be at least 6 characters"
        } else {
            passwordErrorMessage = ""
        }
        
        validateReEnterPassword()
    }
    
    /// Validates if the re-entered password matches the original password
    func validateReEnterPassword() {
        if reEnterPassword != password && !reEnterPassword.isEmpty {
            reEnterPasswordErrorMessage = "Passwords do not match"
        } else {
            reEnterPasswordErrorMessage = ""
        }
    }
}

