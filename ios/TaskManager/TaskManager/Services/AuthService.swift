//
//  AuthService.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import Foundation
import FirebaseAuth // Import Firebase Authentication for handling user authentication
import Combine // Import Combine framework to handle reactive programming

// AuthService is responsible for managing user authentication in the app.
class AuthService: ObservableObject {
    // `isAuthenticated` is a published property that notifies views when the authentication status changes.
    @Published var isAuthenticated: Bool = false
    // `errorMessage` is used to store authentication-related error messages.
    @Published var errorMessage: String?
    
    // Singleton instance of AuthService to ensure only one instance exists throughout the app.
    static let shared = AuthService()
    
    // Private initializer prevents other instances from being created outside this class.
    private init() {
        // Firebase listener to track authentication state changes.
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // Updates `isAuthenticated` whenever the authentication state changes.
            self?.isAuthenticated = user != nil
        }
    }
    
    // MARK: - User Authentication Methods

      /// Sign Up with Email and Password
      /// - Parameters:
      ///   - email: The email address of the user
      ///   - password: The password chosen by the user
      ///   - completion: A closure that returns `true` if successful, otherwise `false`
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                // If an error occurs, store the error message and return `false`
                self?.errorMessage = error.localizedDescription
                completion(false)
            } else {
                // If sign-up is successful, return `true`
                completion(true)
            }
        }
    }
    
    /// Sign In with Email and Password
      /// - Parameters:
      ///   - email: The user's email address
      ///   - password: The user's password
      ///   - completion: A closure that returns `true` if login is successful, otherwise `false`
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                // If an error occurs, store the error message and return `false`
                self?.errorMessage = error.localizedDescription
                completion(false)
            } else {
                // If sign-in is successful, return `true`
                completion(true)
            }
        }
    }
    
    /// Sign Out the currently logged-in user.
    func signOut() {
        do {
            try Auth.auth().signOut() 
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
