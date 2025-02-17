//
//  AuthService.swift
//  TaskManager
//
//  Created by Abhishek G on 17/02/25.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error == nil)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error == nil)
        }
    }
}
