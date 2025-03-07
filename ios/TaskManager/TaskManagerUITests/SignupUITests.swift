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
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let reEnterPasswordField = app.secureTextFields["Re-Enter Password"]

        // Enter valid email id
        emailField.tap()
        emailField.typeText("test@example.com")
        
        // Set clipboard value
        UIPasteboard.general.string = "Password@123"

        // Tap password field and paste text
        passwordField.tap()
        passwordField.doubleTap()
        app.menuItems["Paste"].tap()

        // Set mismatched password in clipboard
        UIPasteboard.general.string = "Password@1234"

        // Tap re-enter password field and paste text
        reEnterPasswordField.tap()
        reEnterPasswordField.doubleTap()
        app.menuItems["Paste"].tap()

        // Tap "Sign Up" button
        app.buttons["Sign Up"].tap()

        // Verify error message
        XCTAssert(app.staticTexts["Passwords do not match"].exists)
    }

    // Test successful signup
    func testSuccessfulSignup() {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let reEnterPasswordField = app.secureTextFields["Re-Enter Password"]
        let successAlert = app.alerts["Success!"]
        let okButton = successAlert.buttons["OK"]
        let loginScreenTitle = app.navigationBars["Login"] // Ensure correct title for login screen
        
        let uniqueEmail = "test+\(UUID().uuidString)@example.com" // Generate unique email
        
        emailField.tap()
        emailField.typeText(uniqueEmail)
        
        // Set clipboard value
        UIPasteboard.general.string = "Password@123"
        
        app.tap()
        
        // Tap password field and paste text
        passwordField.tap()
        passwordField.doubleTap()
        app.menuItems["Paste"].tap()
        
        // Set re-entered password in clipboard
        UIPasteboard.general.string = "Password@123"
        
        // Tap re-enter password field and paste text
        reEnterPasswordField.tap()
        reEnterPasswordField.doubleTap()
        app.menuItems["Paste"].tap()
        
        // Tap Sign Up button
        app.buttons["Sign Up"].tap()
        
        // Verify success alert appears
        XCTAssert(successAlert.waitForExistence(timeout: 5))
        
        // Tap OK button to dismiss alert
        okButton.tap()
        
        // Verify we navigated back to login screen
        XCTAssert(loginScreenTitle.waitForExistence(timeout: 5))
    }
    
    func testExistingEmailSignup() {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let reEnterPasswordField = app.secureTextFields["Re-Enter Password"]
        let failedAlert = app.alerts["Signup Failed"]
        let alertMessage = failedAlert.staticTexts["Email already in use."] // Check alert message
        let okButton = failedAlert.buttons["OK"]

        let existingEmail = "existinguser@example.com" // Use an already registered email

        emailField.tap()
        emailField.typeText(existingEmail)
        
        // Set clipboard value
        UIPasteboard.general.string = "Password@123"
        
        // Tap password field and paste text
        passwordField.tap()
        passwordField.doubleTap()
        app.menuItems["Paste"].tap()
        
        UIPasteboard.general.string = "Password@123"

        // Tap re-enter password field and paste text
        reEnterPasswordField.tap()
        reEnterPasswordField.doubleTap()
        app.menuItems["Paste"].tap()
        
        app.buttons["Sign Up"].tap()

        // Verify failed alert appears
        XCTAssert(failedAlert.waitForExistence(timeout: 5))
        
        // Verify alert message
        XCTAssert(alertMessage.exists)
        
        // Tap OK button to dismiss alert
        okButton.tap()
    }
    
}
