//
//  LoginView.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Login") {
                AuthService.shared.signIn(email: email, password: password, completion: { success in
                    //Navigate to TaskList
                })
            }
        }
    }
}

#Preview {
    LoginView()
}
