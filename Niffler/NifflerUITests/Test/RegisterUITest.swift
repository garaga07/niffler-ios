//
//  RegisterUITest.swift
//  Niffler
//
//  Created by team on 02.12.2024.
//

import XCTest

final class RegisterUITest: XCTestCase {
    func testRegisterNewUser() throws {
        let app = XCUIApplication()
                app.launch()
                
                // Нажимаем "Create new account"
                app.staticTexts["Create new account"].tap()
                
                // Генерация уникального имени пользователя
                let uniqueUserName = "user\(Int(Date().timeIntervalSince1970))"
                let registrationForm = app.otherElements.containing(.button, identifier: "Sign Up").firstMatch
                
                let userNameTextField = registrationForm.textFields["userNameTextField"]
                XCTAssertTrue(userNameTextField.waitForExistence(timeout: 1), "userNameTextField did not appear on the registration screen.")
                userNameTextField.tap()
                userNameTextField.typeText(uniqueUserName)
                
                // Заполняем passwordTextField
                let passwordTextField = registrationForm.secureTextFields["passwordTextField"]
                XCTAssertTrue(passwordTextField.waitForExistence(timeout: 1), "passwordTextField did not appear on the registration screen.")
                passwordTextField.tap()
                passwordTextField.typeText("12345")
                
                // Заполняем confirmPasswordTextField
                let confirmPasswordTextField = registrationForm.secureTextFields["confirmPasswordTextField"]
                XCTAssertTrue(confirmPasswordTextField.waitForExistence(timeout: 1), "confirmPasswordTextField did not appear on the registration screen.")
                confirmPasswordTextField.tap()
                confirmPasswordTextField.typeText("12345")
                
                // Ждём появления кнопки "Sign Up"
                let signUpButton = app.buttons["Sign Up"]
                XCTAssertTrue(signUpButton.waitForExistence(timeout: 1), "Sign Up button did not appear on the registration screen.")
                // Нажимаем "Sign Up"
                XCTAssertTrue(signUpButton.isHittable, "Sign Up button is not tappable.")
                signUpButton.tap()
                
                // Проверяем, что появилось модальное окно "Congratulations!"
                let modalTitle = app.staticTexts["Congratulations!"]
                XCTAssertTrue(modalTitle.waitForExistence(timeout: 1), "The modal window with 'Congratulations!' did not appear.")
                
                // Проверяем текст "You've registered!"
                let registrationMessage = app.staticTexts[" You've registered!"]
                XCTAssertTrue(registrationMessage.waitForExistence(timeout: 1), "The text ' You've registered!' did not appear on the modal window.")
                
                // Тапаем на кнопку "Log in", привязанную к модальному окну
                let modal = app.otherElements.containing(.staticText, identifier: "Congratulations!").firstMatch
                let logInButton = modal.buttons["Log in"]
                XCTAssertTrue(logInButton.waitForExistence(timeout: 1), "The 'Log in' button in the modal window did not appear.")
                logInButton.tap()
                
                // Проверяем наличие заголовка "Log in" на экране
                let loginScreenTitle = app.staticTexts["Log in"]
                XCTAssertTrue(
                    loginScreenTitle.waitForExistence(timeout: 2),
                    "The 'Log in' title did not appear on the screen."
                )
    }
    
    func testUserRegistrationWithLoginInput() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Генерация уникального имени пользователя
        let uniqueUserName = "user\(Int(Date().timeIntervalSince1970))"
        
        // Заполняем поле userNameTextField
        let userNameTextField = app.textFields["userNameTextField"]
        XCTAssertTrue(
            userNameTextField.waitForExistence(timeout: 1),
            "The 'userNameTextField' did not appear on the login screen."
        )
        userNameTextField.tap()
        userNameTextField.typeText(uniqueUserName)
        
        // Заполняем поле passwordTextField
        let passwordTextField = app.secureTextFields["passwordTextField"]
        XCTAssertTrue(
            passwordTextField.waitForExistence(timeout: 1),
            "The 'passwordTextField' did not appear on the login screen."
        )
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        
        // Ожидаем появления текста "Create new account" на экране
        let createNewAccountButton = app.staticTexts["Create new account"]
        XCTAssertTrue(
            createNewAccountButton.waitForExistence(timeout: 1),
            "The 'Create new account' text did not appear on the screen."
        )
        createNewAccountButton.tap()
        
        // Переходим на экран регистрации
        let registrationForm = app.otherElements.containing(.button, identifier: "Sign Up").firstMatch
        let registrationUserNameTextField = registrationForm.textFields["userNameTextField"]
        XCTAssertTrue(
            registrationUserNameTextField.waitForExistence(timeout: 1),
            "The 'userNameTextField' did not appear on the registration screen."
        )
        
        // Проверяем, что значение в поле userNameTextField совпадает с uniqueUserName
        let actualUserName = registrationUserNameTextField.value as? String
        XCTAssertEqual(
            actualUserName,
            uniqueUserName,
            "The 'userName' value '\(String(describing: actualUserName))' does not match the expected '\(uniqueUserName)'."
        )
        
        // Находим поле для ввода пароля
        let registrationPasswordTextField = registrationForm.secureTextFields["passwordTextField"]
        XCTAssertTrue(
            registrationPasswordTextField.waitForExistence(timeout: 1),
            "The 'passwordTextField' did not appear on the registration screen."
        )

        // Проверяем значение в поле пароля
        let passwordValue = registrationPasswordTextField.value as? String
        XCTAssertEqual(
            passwordValue,
            "•••••",
            "The 'password' value '\(String(describing: passwordValue))' does not match the expected value."
        )
    }
}
