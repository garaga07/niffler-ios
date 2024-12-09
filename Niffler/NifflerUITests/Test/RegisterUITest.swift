//
//  RegisterUITest.swift
//  Niffler
//
//  Created by team on 02.12.2024.
//

import XCTest

final class RegisterUITest: XCTestCase {
    var app: XCUIApplication!
    
    func testRegisterNewUser() throws {
        XCTContext.runActivity(named: "Тест регистрации нового пользователя") { _ in
            
            // Arrange
            launchApp()
            let uniqueUserName = generateUniqueUserName()
            
            // Act
            navigateToRegistrationScreen()
            let registrationForm = getRegistrationForm()
            registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345", on: registrationForm)
            
            // Assert
            verifyCongratulationsModal()
            tapLogInButtonInModal()
            verifyScreenTitle("Log in")
        }
    }
    
    func testLoginScreenValuesPersistedToRegistrationScreen() throws {
        XCTContext.runActivity(named: "Проверка переноса данных с логина на экран регистрации") { _ in
            
            // Arrange
            launchApp()
            let uniqueUserName = generateUniqueUserName()
            
            // Act
            fillUserName(in: app, uniqueUserName)
            fillPassword(in: app, "12345")
            navigateToRegistrationScreen()
            
            // Assert
            let registrationForm = getRegistrationForm()
            let registrationUserNameTextField = registrationForm.textFields["userNameTextField"]
            verifyTextFieldValue(
                registrationUserNameTextField,
                expectedValue: "duck",
                message: "The 'userName' value does not match the expected value."
            )
            
            let registrationPasswordTextField = registrationForm.secureTextFields["passwordTextField"]
            verifySecureFieldValue(
                registrationPasswordTextField,
                expectedPlaceholder: "•••••",
                message: "The 'password' value does not match the expected placeholder."
            )
        }
    }
    
    // MARK: - Domain Specific Language
    private func launchApp(){
        XCTContext.runActivity(named: "Запуск приложения") { _ in
            app = XCUIApplication()
            app.launch()
        }
    }
    
    private func navigateToRegistrationScreen() {
        XCTContext.runActivity(named: "Переход на экран регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func generateUniqueUserName() -> String {
        XCTContext.runActivity(named: "Генерация уникального имени пользователя") { _ in
            let uniqueUserName = "user\(Int(Date().timeIntervalSince1970))"
            XCTContext.runActivity(named: "Сгенерирован логин: \(uniqueUserName)") { _ in }
            return uniqueUserName
        }
    }
    
    private func getRegistrationForm() -> XCUIElement {
        XCTContext.runActivity(named: "Получение формы регистрации") { _ in
            let registrationForm = app.otherElements.containing(.button, identifier: "Sign Up").firstMatch
            waitForElement(registrationForm, message: "The registration form did not appear on the screen.")
            return registrationForm
        }
    }
    
    private func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 1, message: String, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидание элемента") { _ in
            XCTAssertTrue(element.waitForExistence(timeout: timeout), message, file: file, line: line)
        }
    }
    
    private func fillUserName(in container: XCUIElement, _ userName: String) {
        XCTContext.runActivity(named: "Ввожу имя пользователя: \(userName)") { _ in
            let userNameTextField = container.textFields["userNameTextField"]
            waitForElement(userNameTextField, message: "The 'userNameTextField' did not appear in the given container.")
            userNameTextField.tap()
            userNameTextField.typeText(userName)
        }
    }
    
    private func fillPassword(in container: XCUIElement, _ password: String) {
        XCTContext.runActivity(named: "Ввожу пароль: \(password)") { _ in
            let passwordTextField = container.secureTextFields["passwordTextField"]
            waitForElement(passwordTextField, message: "The 'passwordTextField' did not appear in the given container.")
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
    }
    
    private func fillConfirmPassword(in container: XCUIElement, _ confirmPassword: String) {
        XCTContext.runActivity(named: "Подтверждаю пароль: \(confirmPassword)") { _ in
            let confirmPasswordTextField = container.secureTextFields["confirmPasswordTextField"]
            waitForElement(confirmPasswordTextField, message: "The 'confirmPasswordTextField' did not appear in the given container.")
            confirmPasswordTextField.tap()
            confirmPasswordTextField.typeText(confirmPassword)
        }
    }
    
    private func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Sign Up'") { _ in
            let signUpButton = app.buttons["Sign Up"]
            waitForElement(signUpButton, message: "Sign Up button did not appear on the registration screen.")
            XCTAssertTrue(signUpButton.isHittable, "Sign Up button is not tappable.")
            signUpButton.tap()
        }
        
    }
    
    private func verifyCongratulationsModal() {
        XCTContext.runActivity(named: "Проверяю модальное окно 'Congratulations!'") { _ in
            let modalTitle = app.staticTexts["Congratulations!"]
            waitForElement(modalTitle, message: "The modal window with 'Congratulations!' did not appear.")
            
            let registrationMessage = app.staticTexts[" You've registered!"]
            waitForElement(registrationMessage, message: "The text ' You've registered!' did not appear on the modal window.")
        }
    }
    
    private func tapLogInButtonInModal(file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Log in' в модальном окне 'Congratulations!'") { _ in
            let modal = app.otherElements.containing(.staticText, identifier: "Congratulations!").firstMatch
            let logInButton = modal.buttons["Log in"]
            
            waitForElement(logInButton, message: "The 'Log in' button in the modal window did not appear.", file: file, line: line)
            XCTAssertTrue(logInButton.isHittable, "The 'Log in' button is not tappable.", file: file, line: line)
            logInButton.tap()
        }
    }
    
    private func verifyScreenTitle(_ title: String, timeout: TimeInterval = 2) {
        XCTContext.runActivity(named: "Проверяю заголовок экрана: \(title)") { _ in
            let screenTitle = app.staticTexts[title]
            waitForElement(screenTitle, timeout: timeout, message: "The '\(title)' title did not appear on the screen.")
        }
    }
    
    private func verifyTextFieldValue(_ textField: XCUIElement, expectedValue: String, message: String) {
        XCTContext.runActivity(named: "Проверяю значение текстового поля: \(expectedValue)") { _ in
            waitForElement(textField, message: "The text field did not appear.")
            let actualValue = textField.value as? String
            XCTAssertEqual(
                actualValue,
                expectedValue,
                "\(message). Expected: '\(expectedValue)', but got: '\(String(describing: actualValue))'."
            )
        }
    }
    
    private func verifySecureFieldValue(_ secureField: XCUIElement, expectedPlaceholder: String, message: String) {
        XCTContext.runActivity(named: "Проверяю значение защищённого поля: \(expectedPlaceholder)") { _ in
            waitForElement(secureField, message: "The secure text field did not appear.")
            let actualValue = secureField.value as? String
            XCTAssertEqual(
                actualValue,
                expectedPlaceholder,
                "\(message). Expected: '\(expectedPlaceholder)', but got: '\(String(describing: actualValue))'."
            )
        }
    }
    
    private func registerUser(
        userName: String,
        password: String,
        confirmPassword: String,
        on registrationForm: XCUIElement
    ) {
        XCTContext.runActivity(named: "Регистрирую пользователя с логином: \(userName)") { _ in
            fillUserName(in: registrationForm, userName)
            fillPassword(in: registrationForm, password)
            fillConfirmPassword(in: registrationForm, confirmPassword)
            tapSignUpButton()
        }
    }
}
