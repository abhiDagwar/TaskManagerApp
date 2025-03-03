//
//  SignupUITests.swift
//  TaskManagerUITests
//
//  Created by Abhishek G on 03/03/25.
//

import XCTest

final class SignupUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
      continueAfterFailure = false
      app.launch()
      app.buttons["Create Account"].tap() // Navigate to Signup screen
    }

    // Test empty form submission
    func testEmptyForm() {
      app.buttons["Sign Up"].tap()
      XCTAssert(app.staticTexts["Email is required"].exists)
      XCTAssert(app.staticTexts["Password is required"].exists)
    }

    // Test invalid email format
    func testInvalidEmail() {
      let emailField = app.textFields["Email"]
      emailField.tap()
      emailField.typeText("invalid-email")
      app.buttons["Sign Up"].tap()
      XCTAssert(app.staticTexts["Invalid email format"].exists)
    }

    // Test password mismatch
    func testPasswordMismatch() {
      let passwordField = app.secureTextFields["Password"]
      let reEnterPasswordField = app.secureTextFields["Re-Enter Password"]
      passwordField.tap()
      passwordField.typeText("Password@123")
      reEnterPasswordField.tap()
      reEnterPasswordField.typeText("wrongpass")
      XCTAssert(app.staticTexts["Passwords do not match"].exists)
    }

    // Test successful signup
    func testSuccessfulSignup() {
      let emailField = app.textFields["Email"]
      let passwordField = app.secureTextFields["Password"]
      let reEnterPasswordField = app.secureTextFields["Re-Enter Password"]
      
      emailField.tap()
      emailField.typeText("test@example.com")
      passwordField.tap()
      passwordField.typeText("Password@123")
      reEnterPasswordField.tap()
      reEnterPasswordField.typeText("Password@123")
      app.buttons["Sign Up"].tap()
      
      // Verify navigation to another screen (e.g., Task List)
      XCTAssert(app.navigationBars["Tasks"].waitForExistence(timeout: 10))
    }
}
