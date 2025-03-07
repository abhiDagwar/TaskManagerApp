//
//  LoginView.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
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
                            text: $email
                        )
                        .onChange(of: email) {
                            emailErrorMessage = ""
                        }
                        
                        if !emailErrorMessage.isEmpty {
                            ErrorMessage(text: emailErrorMessage)
                        }
                        
                        CustomTextField(
                            title: "Password",
                            icon: "lock",
                            text: $password,
                            isSecure: true
                        )
                        .onChange(of: password) {
                            passwordErrorMessage = ""
                        }
                        
                        if !passwordErrorMessage.isEmpty {
                            ErrorMessage(text: passwordErrorMessage)
                        }
                    }
                    
                    // Login Button
                    CustomButton(
                        title: "Login",
                        action: handleLogin,
                        isLoading: isLoading
                    )
                    
                    // Signup Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color("TextSecondary"))
                        
                        NavigationLink("Sign Up") {
                            SignupView()
                        }
                        .foregroundColor(Color("PrimaryColor"))
                    }
                }
                .padding()
            }
            
            // Alert
            if showAlert {
                Color.black.opacity(0.4).ignoresSafeArea()
                CustomAlertView(
                    title: "Login Failed",
                    message: alertMessage,
                    primaryButtonTitle: "OK",
                    primaryAction: { showAlert = false }
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleLogin() {
        validateForm()
        guard emailErrorMessage.isEmpty && passwordErrorMessage.isEmpty else { return }
        
        isLoading = true
        authService.signIn(email: email, password: password) { success in
            isLoading = false
            if !success {
                alertMessage = authService.errorMessage ?? "Invalid email or password"
                showAlert = true
            }
        }
    }
    
    private func validateForm() {
        emailErrorMessage = Validation.isFieldEmpty(email) ? "Email is required" : ""
        passwordErrorMessage = Validation.isFieldEmpty(password) ? "Password is required" : ""
    }
}

#Preview {
    LoginView()
}
