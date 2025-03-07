//
//  SignupView.swift
//  TaskManager
//
//  Created by Abhishek G on 24/02/25.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.colorScheme) var colorScheme
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
                // Background
                Color("BackgroundColor").ignoresSafeArea()

                VStack {
                    Spacer() // Push content to the center
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            // Header
                            VStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color("PrimaryColor"))
                                
                                Text("Create Account")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(Color("TextPrimary"))
                            }
                            
                            // Form
                            VStack(spacing: 20) {
                                // Email Field
                                VStack(alignment: .leading) {
                                    CustomTextField(
                                        title: "Email",
                                        icon: "envelope",
                                        text: $email
                                    )
                                    .textInputAutocapitalization(.never)
                                    .onChange(of: email) {
                                        emailErrorMessage = ""
                                    }
                                    if !emailErrorMessage.isEmpty {
                                        ErrorMessage(text: emailErrorMessage)
                                    }
                                }
                                
                                // Password Field
                                VStack(alignment: .leading) {
                                    CustomTextField(
                                        title: "Password",
                                        icon: "lock",
                                        text: $password,
                                        isSecure: true
                                    )
                                    .onChange(of: password) {
                                        passwordErrorMessage = ""
                                        validateReEnterPassword()
                                    }
                                    
                                    if !passwordErrorMessage.isEmpty {
                                        ErrorMessage(text: passwordErrorMessage)
                                    }
                                }
                                
                                // Re-Enter Password Field
                                VStack(alignment: .leading) {
                                    CustomTextField(
                                        title: "Re-Enter Password",
                                        icon: "lock.fill",
                                        text: $reEnterPassword,
                                        isSecure: true
                                    )
                                    .onChange(of: password) {
                                        validateReEnterPassword()
                                    }
                                    if !reEnterPasswordErrorMessage.isEmpty {
                                        ErrorMessage(text: reEnterPasswordErrorMessage)
                                    }
                                }
                                
                                // Sign Up Button
                                CustomButton(
                                    title: "Sign Up",
                                    action: handleSignup,
                                    isLoading: isLoading
                                )
                                .disabled(isLoading)
                                
                                // Login Link
                                HStack {
                                    Text("Already have an account?")
                                        .foregroundColor(Color("TextSecondary"))
                                    
                                    Button("Log In") {
                                        dismiss()
                                    }
                                    .foregroundColor(Color("PrimaryColor"))
                                }
                            }
                            .padding()
                        }
                    }

                    Spacer() // Push content to the center
                }
                
                // Alert Overlay
                if showAlert {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    CustomAlertView(
                        title: alertTitle,
                        message: alertMessage,
                        primaryButtonTitle: "OK",
                        primaryAction: {
                            if isSignupSuccessful {
                                dismiss()
                            }
                            showAlert = false
                        }
                    )
                    .transition(.scale)
                }

                // Loading Overlay
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(2)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    // MARK: - Validation
    private func validateForm() {
        if Validation.isFieldEmpty(email) {
            emailErrorMessage = "Email is required"
        } else if !Validation.isValidEmail(email) {
            emailErrorMessage = "Invalid email format"
        }
        
        if Validation.isFieldEmpty(password) {
            passwordErrorMessage = "Password is required"
        } else if !Validation.isValidPassword(password) {
            passwordErrorMessage = "Invalid password format"
        }
        
        validateReEnterPassword()
    }
    
    private func validateReEnterPassword() {
        if reEnterPassword != password && !reEnterPassword.isEmpty {
            reEnterPasswordErrorMessage = "Passwords do not match"
        } else {
            reEnterPasswordErrorMessage = ""
        }
    }
    
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
                alertTitle = "Success!"
                alertMessage = "Account created successfully."
                isSignupSuccessful = true
                showAlert = true
            } else {
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
