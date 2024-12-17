//
//  RegisterUITest.swift
//  Niffler
//
//  Created by team on 02.12.2024.
//

import XCTest

final class RegisterUITest: TestCase {
    
    func testRegisterNewUser() throws {
        XCTContext.runActivity(named: "Тест регистрации нового пользователя") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
                .registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
            
            // Assert
                .verifyCongratulationsModal()
                .tapLogInButtonInModal()
            loginPage.verifyScreenTitle("Log in")
        }
    }
    
    func testLoginScreenValuesPersistedToRegistrationScreen() throws {
        XCTContext.runActivity(named: "Проверка переноса данных с логина на экран регистрации") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.fillUserName(uniqueUserName)
                .fillPassword("12345")
                .navigateToRegistrationScreen()
            
            // Assert
            let registrationForm = registerPage.getRegistrationForm()
            let registrationUserNameTextField = registrationForm.textFields["userNameTextField"]
            registerPage.verifyTextFieldValue(
                registrationUserNameTextField,
                expectedValue: uniqueUserName,
                message: "The 'userName' value does not match the expected value."
            )
            
            let registrationPasswordTextField = registrationForm.secureTextFields["passwordTextField"]
            registerPage.verifySecureFieldValue(
                registrationPasswordTextField,
                expectedPlaceholder: "•••••",
                message: "The 'password' value does not match the expected placeholder."
            )
        }
    }
}
