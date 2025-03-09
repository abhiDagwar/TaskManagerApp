//
//  AuthServiceIntegrationTests.swift
//  TaskManagerTests
//
//  Created by Abhishek G on 03/03/25.
//

import XCTest
@testable import TaskManager
import FirebaseAuth

final class AuthServiceIntegrationTests: XCTestCase {
    var authService: AuthService!
    
    override func setUp() {
        super.setUp()
        authService = AuthService.shared // Real AuthService (NOT mock)
    }
    
    func testRealSignupAPI() {
        let expectation = XCTestExpectation(description: "Signup API call should succeed")
        
        let randomEmail = "test+\(UUID().uuidString)@example.com" // Generates a unique email every time
        
        authService.signUp(email: randomEmail, password: "password123") { success in
            XCTAssertTrue(success, "Signup should succeed with a unique email")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testExistingUserSignup() {
        let expectation = XCTestExpectation(description: "Existing user signup")
        
        authService.signUp(email: "existing@example.com", password: "password123") { success in
            XCTAssertFalse(success, "Signup should fail for existing user")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRealSignInAPI() {
        let expectation = XCTestExpectation(description: "Sign-in API call should succeed")
        
        authService.signIn(email: "test@example.com", password: "password123") { success in
            XCTAssertTrue(success, "Sign-in should succeed with correct credentials")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
