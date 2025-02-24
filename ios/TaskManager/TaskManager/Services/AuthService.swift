//
//  AuthService.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import Foundation
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    static let shared = AuthService()
    
    private init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }
    
    // Sign Up with Email/Password
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Sign In with Email/Password
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
