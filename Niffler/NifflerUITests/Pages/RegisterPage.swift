//
//  RegisterPage.swift
//  Niffler
//
//  Created by team on 11.12.2024.
//

import XCTest

class RegisterPage: BasePage {
    func getRegistrationForm() -> XCUIElement {
        XCTContext.runActivity(named: "Получение формы регистрации") { _ in
            let registrationForm = app.otherElements.containing(.button, identifier: "Sign Up").firstMatch
            waitForElement(registrationForm, message: "The registration form did not appear on the screen.")
            return registrationForm
        }
    }
    
    @discardableResult
    func fillUserName(in container: XCUIElement, _ userName: String) -> Self {
        XCTContext.runActivity(named: "Ввожу имя пользователя: \(userName)") { _ in
            let userNameTextField = container.textFields["userNameTextField"]
            waitForElement(userNameTextField, message: "The 'userNameTextField' did not appear in the given container.")
            userNameTextField.tap()
            userNameTextField.typeText(userName)
        }
        return self
    }
    
    @discardableResult
    func fillPassword(in container: XCUIElement, _ password: String) -> Self {
        XCTContext.runActivity(named: "Ввожу пароль: \(password)"){ _ in
            let passwordTextField = container.secureTextFields["passwordTextField"]
            waitForElement(passwordTextField, message: "The 'passwordTextField' did not appear in the given container.")
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
        return self
    }
    
    @discardableResult
    func fillConfirmPassword(in container: XCUIElement, _ confirmPassword: String) -> Self {
        XCTContext.runActivity(named: "Подтверждаю пароль: \(confirmPassword)") { _ in
            let confirmPasswordTextField = container.secureTextFields["confirmPasswordTextField"]
            waitForElement(confirmPasswordTextField, message: "The 'confirmPasswordTextField' did not appear in the given container.")
            confirmPasswordTextField.tap()
            confirmPasswordTextField.typeText(confirmPassword)
        }
        return self
    }
    
    @discardableResult
    func tapSignUpButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Sign Up'") { _ in
            let signUpButton = app.buttons["Sign Up"]
            waitForElement(signUpButton, message: "Sign Up button did not appear on the registration screen.")
            XCTAssertTrue(signUpButton.isHittable, "Sign Up button is not tappable.")
            signUpButton.tap()
        }
        return self
    }
    
    func verifyCongratulationsModal() -> Self {
        XCTContext.runActivity(named: "Проверяю модальное окно 'Congratulations!'") { _ in
            let modalTitle = app.staticTexts["Congratulations!"]
            waitForElement(modalTitle, message: "The modal window with 'Congratulations!' did not appear.")
            
            let registrationMessage = app.staticTexts[" You've registered!"]
            waitForElement(registrationMessage, message: "The text ' You've registered!' did not appear on the modal window.")
        }
        return self
    }
    
    @discardableResult
    func tapLogInButtonInModal(file: StaticString = #file, line: UInt = #line) -> LoginPage {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Log in' в модальном окне 'Congratulations!'") { _ in
            let modal = app.otherElements.containing(.staticText, identifier: "Congratulations!").firstMatch
            let logInButton = modal.buttons["Log in"]
            
            waitForElement(logInButton, message: "The 'Log in' button in the modal window did not appear.", file: file, line: line)
            XCTAssertTrue(logInButton.isHittable, "The 'Log in' button is not tappable.", file: file, line: line)
            logInButton.tap()
        }
        return LoginPage(app: app)
    }
    
    @discardableResult
    func verifyTextFieldValue(_ textField: XCUIElement, expectedValue: String, message: String) -> Self {
        XCTContext.runActivity(named: "Проверяю значение текстового поля: \(expectedValue)") { _ in
            waitForElement(textField, message: "The text field did not appear.")
            let actualValue = textField.value as? String
            XCTAssertEqual(
                actualValue,
                expectedValue,
                "\(message). Expected: '\(expectedValue)', but got: '\(String(describing: actualValue))'."
            )
        }
        return self
    }
    
    @discardableResult
    func verifySecureFieldValue(_ secureField: XCUIElement, expectedPlaceholder: String, message: String) -> Self {
        XCTContext.runActivity(named: "Проверяю значение защищённого поля: \(expectedPlaceholder)") { _ in
            waitForElement(secureField, message: "The secure text field did not appear.")
            let actualValue = secureField.value as? String
            XCTAssertEqual(
                actualValue,
                expectedPlaceholder,
                "\(message). Expected: '\(expectedPlaceholder)', but got: '\(String(describing: actualValue))'."
            )
        }
        return self
    }
    
    func registerUser(
        userName: String,
        password: String,
        confirmPassword: String
    ) -> Self {
        XCTContext.runActivity(named: "Регистрирую пользователя с логином: \(userName)") { _ in
            let registrationForm = getRegistrationForm()
            fillUserName(in: registrationForm, userName)
            fillPassword(in: registrationForm, password)
            fillConfirmPassword(in: registrationForm, confirmPassword)
            tapSignUpButton()
        }
        return self
    }
}
