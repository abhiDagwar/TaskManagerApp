//
//  SignupView.swift
//  TaskManager
//
//  Created by Abhishek G on 24/02/25.
//

import SwiftUI

struct SignupView: View {
    
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var reEnterPassword = ""
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var reEnterPasswordErrorMessage = ""
    @State private var isLoading = false // For loading state
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isSignupSuccessful = false // For navigation
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading) {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                        // For email field
                            .onChange(of: email) {
                                emailErrorMessage = ""
                            }
                        Text(emailErrorMessage)
                            .errorMessageStyle()
                    }
                    
                    // Password Field
                    VStack(alignment: .leading) {
                        SecureField("Password", text: $password)
                        // For password field
                            .onChange(of: password) {
                                passwordErrorMessage = ""
                                validateReEnterPassword()
                            }
                        Text(passwordErrorMessage)
                            .errorMessageStyle()
                    }
                    
                    // Re-Enter Password Field
                    VStack(alignment: .leading) {
                        SecureField("Re-Enter Password", text: $reEnterPassword)
                            .onChange(of: password) {
                                validateReEnterPassword()
                            }
                        Text(reEnterPasswordErrorMessage)
                            .errorMessageStyle()
                    }
                    
                    // Sign Up Button
                    Button("Sign Up") {
                        handleSignup()
                    }
                    .disabled(isLoading)
                }
                .padding()
                .navigationTitle("Sign Up")
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("OK") {
                        if isSignupSuccessful {
                            dismiss() // Return to login screen on success
                        }
                    }
                } message: {
                    Text(alertMessage)
                }
                // Loading Overlay
                if isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Validation
    private func validateForm() {
        // Email Validation
        if Validation.isFieldEmpty(email) {
            emailErrorMessage = "Email is required"
        } else if !Validation.isValidEmail(email) {
            emailErrorMessage = "Invalid email format"
        }
        
        // Password Validation
        if Validation.isFieldEmpty(password) {
            passwordErrorMessage = "Password is required"
        } else if !Validation.isValidPassword(password) {
            passwordErrorMessage = "Invalid password format"
        }
        
        // Re-Enter Password Validation
        validateReEnterPassword()
    }
    
    private func validateReEnterPassword() {
        if reEnterPassword != password && !reEnterPassword.isEmpty {
            reEnterPasswordErrorMessage = "Passwords do not match"
        } else {
            reEnterPasswordErrorMessage = ""
        }
    }
    
    // Updated signup logic
    private func handleSignup() {
        validateForm()
        guard emailErrorMessage.isEmpty,
              passwordErrorMessage.isEmpty,
              reEnterPasswordErrorMessage.isEmpty
        else { return }
        
        isLoading = true
        authService.signUp(email: email, password: password) { success in
            isLoading = false
            
            if success {
                // Successful signup
                alertTitle = "Success!"
                alertMessage = "Account created successfully."
                isSignupSuccessful = true
                showAlert = true
            } else {
                // Handle errors
                alertTitle = "Signup Failed"
                alertMessage = authService.errorMessage ?? "Unknown error"
                showAlert = true
            }
        }
    }
    
}

#Preview {
    SignupView()
}
