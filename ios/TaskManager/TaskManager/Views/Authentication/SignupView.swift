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
    @Environment(\.dismiss) var dismiss         // For navigation back
    @StateObject private var viewModel = SignupViewModel() // Using ViewModel
    
    var body: some View {
        NavigationStack { // Add NavigationStack
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
                                        text: $viewModel.email
                                    )
                                    .textInputAutocapitalization(.never)
                                    .onChange(of: viewModel.email) {
                                        viewModel.emailErrorMessage = ""
                                    }
                                    if !viewModel.emailErrorMessage.isEmpty {
                                        ErrorMessage(text: viewModel.emailErrorMessage)
                                    }
                                }
                                
                                // Password Field
                                VStack(alignment: .leading) {
                                    CustomTextField(
                                        title: "Password",
                                        icon: "lock",
                                        text: $viewModel.password,
                                        isSecure: true
                                    )
                                    .onChange(of: viewModel.password) {
                                        viewModel.passwordErrorMessage = ""
                                        viewModel.validateReEnterPassword()
                                    }
                                    
                                    if !viewModel.passwordErrorMessage.isEmpty {
                                        ErrorMessage(text: viewModel.passwordErrorMessage)
                                    }
                                }
                                
                                // Re-Enter Password Field
                                VStack(alignment: .leading) {
                                    CustomTextField(
                                        title: "Re-Enter Password",
                                        icon: "lock.fill",
                                        text: $viewModel.reEnterPassword,
                                        isSecure: true
                                    )
                                    .onChange(of: viewModel.password) {
                                        viewModel.validateReEnterPassword()
                                    }
                                    if !viewModel.reEnterPasswordErrorMessage.isEmpty {
                                        ErrorMessage(text: viewModel.reEnterPasswordErrorMessage)
                                    }
                                }
                                
                                // Sign Up Button
                                CustomButton(
                                    title: "Sign Up",
                                    action: viewModel.handleSignup,
                                    isLoading: viewModel.isLoading
                                )
                                .disabled(viewModel.isLoading)
                                
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
                if viewModel.showAlert {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    CustomAlertView(
                        title: viewModel.alertTitle,
                        message: viewModel.alertMessage,
                        primaryButtonTitle: "OK",
                        primaryAction: {
                            if viewModel.isSignupSuccessful {
                                dismiss()
                            }
                            viewModel.showAlert = false
                        }
                    )
                    .transition(.scale)
                }

                // Loading Overlay
                if viewModel.isLoading {
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
    // Removed validation functions as they are now in the view model
    
    // Removed handleSignup function as it is now in the view model
}

#Preview {
    SignupView()
}
