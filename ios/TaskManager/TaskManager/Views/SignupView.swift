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
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Sign Up") {
                authService.signUp(email: email, password: password) { success in
                    // Handle success/failure
                }
            }
        }
        .padding()
    }
}

#Preview {
    SignupView()
}
