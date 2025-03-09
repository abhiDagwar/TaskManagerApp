//
//  SignupAPITests.swift
//  TaskManagerTests
//
//  Created by Abhishek G on 03/03/25.
//

import XCTest
@testable import TaskManager

final class SignupAPITests: XCTestCase {
    
    var mockAuthService: MockAuthService!

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService() // Create fresh instance for each test
    }

    /// ✅ Tests successful signup for a new user
    func testSignupNewUser() {
        let expectation = XCTestExpectation(description: "Signup API call")
        mockAuthService.shouldSucceed = true
        
        mockAuthService.signUp(email: "newuser@example.com", password: "password123") { success in
            XCTAssertTrue(success, "Signup should succeed for new user")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    /// ✅ Tests signup failure when email already exists
    func testExistingUserSignup() {
        let expectation = XCTestExpectation(description: "Existing user signup")
        
        mockAuthService.signUp(email: "existing@example.com", password: "password123") { success in
            XCTAssertFalse(success, "Signup should fail for existing user")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    /// ✅ Tests successful login for an existing user
    func testSignInValidCredentials() {
        let expectation = XCTestExpectation(description: "Valid login test")
        
        mockAuthService.signIn(email: "existing@example.com", password: "password123") { success in
            XCTAssertTrue(success, "Login should succeed with correct credentials")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    /// ✅ Tests failed login due to incorrect credentials
    func testSignInInvalidCredentials() {
        let expectation = XCTestExpectation(description: "Invalid login test")
        
        mockAuthService.signIn(email: "existing@example.com", password: "wrongpassword") { success in
            XCTAssertFalse(success, "Login should fail for incorrect password")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    /// ✅ Tests login failure for a non-existent user
    func testSignInNonExistentUser() {
        let expectation = XCTestExpectation(description: "Non-existent user login test")
        
        mockAuthService.signIn(email: "notfound@example.com", password: "password123") { success in
            XCTAssertFalse(success, "Login should fail for non-existent user")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
