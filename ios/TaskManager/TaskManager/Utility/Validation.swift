//
//  Validation.swift
//  TaskManager
//
//  Created by Abhishek G on 28/02/25.
//

import Foundation

struct Validation {
    
    // No email/password format validation (only check for empty fields)
    static func isFieldEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /// Validates an email using a refined regex pattern.
    /// - Parameter email: The email address to validate.
    /// - Returns: `true` if the email is valid, otherwise `false`.
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// Validates a password with security requirements.
    /// - Parameter password: The password to validate.
    /// - Returns: `true` if the password is strong, otherwise `false`.
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
