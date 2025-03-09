//
//  LoginView.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import SwiftUI

/// View for user login screen
struct LoginView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: LoginViewModel
    
    /// Initializes the view with an authentication service
    /// - Parameter authService: The service responsible for authentication operations
    init(authService: AuthService = AuthService.shared) { 
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("Welcome Back")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("TextPrimary"))
                    }
                    
                    // Form
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Email",
                            icon: "envelope",
                            text: $viewModel.email
                        )
                        .onChange(of: viewModel.email) {
                            viewModel.emailErrorMessage = ""
                        }
                        
                        if !viewModel.emailErrorMessage.isEmpty {
                            ErrorMessage(text: viewModel.emailErrorMessage)
                        }
                        
                        CustomTextField(
                            title: "Password",
                            icon: "lock",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        .onChange(of: viewModel.password) {
                            viewModel.passwordErrorMessage = ""
                        }
                        
                        if !viewModel.passwordErrorMessage.isEmpty {
                            ErrorMessage(text: viewModel.passwordErrorMessage)
                        }
                    }
                    
                    // Login Button
                    CustomButton(
                        title: "Login",
                        action: viewModel.login,
                        isLoading: viewModel.isLoading
                    )
                    
                    // Signup Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color("TextSecondary"))

                        NavigationLink("Sign Up", destination: SignupView())
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                .padding()
            }
            
            if viewModel.showAlert {
                Color.black.opacity(0.4).ignoresSafeArea()
                CustomAlertView(
                    title: "Login Failed",
                    message: viewModel.alertMessage,
                    primaryButtonTitle: "OK",
                    primaryAction: { viewModel.showAlert = false }
                )
            }
        }
        .navigationBarHidden(true)
    }
}

// Preview now works without needing to pass `authService`
#Preview {
    LoginView()
}
