//
//  SignupView.swift
//  TaskManager
//
//  Created by Abhishek G on 24/02/25.
//

import SwiftUI

struct SignupView: View {
  @EnvironmentObject var authService: AuthService
  @State private var email = ""
  @State private var password = ""
  @State private var reEnterPassword = ""
  @State private var emailErrorMessage = ""
  @State private var passwordErrorMessage = ""
  @State private var reEnterPasswordErrorMessage = ""
  @State private var isLoading = false // For loading state

  var body: some View {
    NavigationView {
      ZStack {
        VStack(spacing: 20) {
          // Email Field
          VStack(alignment: .leading) {
            TextField("Email", text: $email)
              .textInputAutocapitalization(.never)
              .onChange(of: email) { _ in
                emailErrorMessage = ""
              }
            Text(emailErrorMessage)
              .errorMessageStyle()
          }

          // Password Field
          VStack(alignment: .leading) {
            SecureField("Password", text: $password)
              .onChange(of: password) { _ in
                passwordErrorMessage = ""
                validateReEnterPassword()
              }
            Text(passwordErrorMessage)
              .errorMessageStyle()
          }

          // Re-Enter Password Field
          VStack(alignment: .leading) {
            SecureField("Re-Enter Password", text: $reEnterPassword)
              .onChange(of: reEnterPassword) { _ in
                validateReEnterPassword()
              }
            Text(reEnterPasswordErrorMessage)
              .errorMessageStyle()
          }

          // Sign Up Button
          Button("Sign Up") {
            validateForm()
            if emailErrorMessage.isEmpty && passwordErrorMessage.isEmpty && reEnterPasswordErrorMessage.isEmpty {
              isLoading = true
              authService.signUp(email: email, password: password) { success in
                isLoading = false
                // Handle success/failure (e.g., show alert)
              }
            }
          }
          .disabled(isLoading)
        }
        .padding()
        .navigationTitle("Sign Up")

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
      passwordErrorMessage = "Password must be ≥8 characters"
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
}

#Preview {
    SignupView()
}
