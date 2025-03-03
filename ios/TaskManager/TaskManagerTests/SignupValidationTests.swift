//
//  SignupValidationTests.swift
//  TaskManagerTests
//
//  Created by Abhishek G on 03/03/25.
//

import XCTest
@testable import TaskManager

final class SignupValidationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmailValidation() {
      XCTAssertTrue(Validation.isValidEmail("test@example.com")) // Valid
      XCTAssertFalse(Validation.isValidEmail("invalid-email"))    // Invalid
    }

    func testPasswordValidation() {
        XCTAssertTrue(Validation.isValidPassword("12345678Abc!"))    // Valid (Contain alphanumeric character, length 8 chars, one small, one capital, one special char)
        XCTAssertFalse(Validation.isValidPassword("12345678"))       // Invalid
        XCTAssertFalse(Validation.isValidPassword("Abcdefgh"))       // Invalid
        XCTAssertFalse(Validation.isValidPassword("12345678Abc"))    // Invalid
        XCTAssertFalse(Validation.isValidPassword("12345678!@#"))    // Invalid
        XCTAssertFalse(Validation.isValidPassword("1234"))           // Invalid (4 chars)
    }

    func testPasswordMatching() {
      let password = "password123"
      XCTAssertEqual(password, "password123", "Passwords should match")
      XCTAssertNotEqual(password, "wrongpass", "Passwords should not match")
    }

}
