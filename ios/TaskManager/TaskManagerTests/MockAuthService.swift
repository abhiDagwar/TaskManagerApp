//
//  SignupAPITests.swift
//  TaskManagerTests
//
//  Created by Abhishek G on 03/03/25.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)
}

class MockAuthService: AuthServiceProtocol {
    var shouldSucceed = true
    var existingUsers: [String: String] // Dictionary to store email-password pairs
    
    init(existingUsers: [String: String] = ["existing@example.com": "password123"]) {
        self.existingUsers = existingUsers
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // If email already exists, fail signup
        if existingUsers.keys.contains(email) {
            completion(false)
        } else {
            existingUsers[email] = password // Simulate storing the new user
            completion(shouldSucceed)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Check if the email exists and password matches
        if let storedPassword = existingUsers[email], storedPassword == password {
            completion(shouldSucceed)
        } else {
            completion(false)
        }
    }
}

