//
//  LoginView.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authService: AuthService
  @State private var email = ""
  @State private var password = ""
  @State private var emailErrorMessage = ""
  @State private var passwordErrorMessage = ""

  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        // Email Field
        VStack(alignment: .leading) {
          TextField("Email", text: $email)
            .textInputAutocapitalization(.never)
          Text(emailErrorMessage)
            .errorMessageStyle()
        }

        // Password Field
        VStack(alignment: .leading) {
          SecureField("Password", text: $password)
          Text(passwordErrorMessage)
            .errorMessageStyle()
        }

        // Login Button
        Button("Login") {
          validateForm()
          if emailErrorMessage.isEmpty && passwordErrorMessage.isEmpty {
            authService.signIn(email: email, password: password) { success in
              // Handle login result
            }
          }
        }

        NavigationLink("Create Account", destination: SignupView())
      }
      .padding()
      .navigationTitle("Login")
    }
  }

  // Simplified validation (only check for empty fields)
  private func validateForm() {
    emailErrorMessage = Validation.isFieldEmpty(email) ? "Email is required" : ""
    passwordErrorMessage = Validation.isFieldEmpty(password) ? "Password is required" : ""
  }
}

#Preview {
    LoginView()
}
