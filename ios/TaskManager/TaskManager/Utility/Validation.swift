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
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Validates an email address format
    /// - Parameter email: Email to validate
    /// - Returns: True if the email format is valid, otherwise false
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validates password requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if the password meets requirements, otherwise false
    static func isValidPassword(_ password: String) -> Bool {
        // Password should be at least 6 characters
        // You can add more complex validation here if needed
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    /// Validates task title
    /// - Parameter title: Title to validate
    /// - Returns: True if the title is valid, otherwise false
    static func isValidTaskTitle(_ title: String) -> Bool {
        // Title should not be empty and have reasonable length
        return !isFieldEmpty(title) && title.count <= 50
    }
    
    /// Validates task description
    /// - Parameter description: Description to validate
    /// - Returns: True if the description is valid, otherwise false
    static func isValidTaskDescription(_ description: String) -> Bool {
        // Description can be empty but should have reasonable length if provided
        return description.count <= 500
    }
}
