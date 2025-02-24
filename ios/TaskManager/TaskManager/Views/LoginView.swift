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
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Login") {
                authService.signIn(email: email, password: password) { success in
                    // Handle success/failure
                }
            }
            //NavigationLink("Create Account", destination: SignupView())
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
