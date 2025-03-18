//
//  AuthService.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import Foundation
import FirebaseAuth
import Combine

/// Service responsible for managing user authentication in the app
class AuthService: ObservableObject {
    // MARK: - Published Properties
    
    /// Indicates whether a user is currently authenticated
    @Published var isAuthenticated: Bool = false
    /// Stores the current login user id if the user is authenticated
    @Published var userId: String? = nil
    /// Stores the most recent authentication error message
    @Published var errorMessage: String?

    /// Singleton instance to ensure only one instance exists throughout the app
    static let shared = AuthService()
    
    /// Stores the authentication listener handle
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    /// Private initializer prevents other instances from being created
    private init() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            self?.userId = user?.uid
        }
    }

    // MARK: - User Authentication Methods

    /// Sign Up with Email and Password
    /// - Parameters:
    ///   - email: The email address of the user
    ///   - password: The password chosen by the user
    ///   - completion: A closure that returns `(Bool, String?)`, success state and optional error message.
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                let errorMessage: String
                switch AuthErrorCode(rawValue: error._code) {
                    case .emailAlreadyInUse:
                        errorMessage = "Email already in use."
                    case .weakPassword:
                        errorMessage = "Password must be at least 6 characters."
                    case .networkError:
                        errorMessage = "Network error. Check your connection."
                    default:
                        errorMessage = "Signup failed. Please try again."
                }
                self?.errorMessage = errorMessage
                completion(false)
            } else if let user = result?.user {
                self?.isAuthenticated = true
                self?.userId = user.uid
                self?.errorMessage = nil
                completion(true)
            } else {
                self?.errorMessage = "Unknown error occurred."
                completion(false)
            }
        }
    }

    /// Sign In with Email and Password
    /// - Parameters:
    ///   - email: The user's email address
    ///   - password: The user's password
    ///   - completion: A closure that returns `(Bool, String?)`
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                let errorMessage: String
                switch AuthErrorCode(rawValue: error._code) {
                    case .wrongPassword:
                        errorMessage = "Incorrect password. Please try again."
                    case .userNotFound:
                        errorMessage = "No account found with this email."
                    case .networkError:
                        errorMessage = "Network issue. Check your internet connection."
                    default:
                        errorMessage = "Login failed. Please try again."
                }
                self?.errorMessage = errorMessage
                completion(false)
            } else if let user = result?.user {
                self?.isAuthenticated = true
                self?.userId = user.uid
                self?.errorMessage = nil
                completion(true)
            } else {
                self?.errorMessage = "Unknown error occurred."
                completion(false)
            }
        }
    }

    /// Sign Out the currently logged-in user.
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            userId = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    /// Removes the authentication listener when no longer needed
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
