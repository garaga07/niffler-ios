import XCTest

class LoginPage: BasePage {
    
    func login(userName: String, password: String) {
        XCTContext.runActivity(named: "Выполняю вход с именем пользователя '\(userName)' и паролем") { _ in
            fillUserName(userName)
            fillPassword(password)
            pressLoginButton()
        }
    }
    
    func fillUserName(_ userName: String) {
        XCTContext.runActivity(named: "Ввожу имя пользователя: \(userName)") { _ in
            let userNameTextField = app.textFields["userNameTextField"]
            waitForElement(userNameTextField, message: "The 'userNameTextField' did not appear on the screen.")
            userNameTextField.tap()
            userNameTextField.typeText(userName)
        }
    }
    
    func fillPassword(_ password: String) {
        XCTContext.runActivity(named: "Ввожу пароль: \(password)") { _ in
            let passwordTextField = app.secureTextFields["passwordTextField"]
            waitForElement(passwordTextField, message: "The 'passwordTextField' did not appear on the screen.")
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
    }
    
    func pressLoginButton() {
        XCTContext.runActivity(named: "Жму кнопку логина") { _ in
            let loginButton = app.buttons["loginButton"]
            waitForElement(loginButton, message: "Login button did not appear on the login screen.")
            XCTAssertTrue(loginButton.isHittable, "Login button is not tappable.")
            app.buttons["loginButton"].tap()
        }
    }
    
    func assertIsLoginErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let isFound = app.staticTexts["LoginError"]
                .waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Не нашли сообщение о неправильном логине",
                          file: file, line: line)
        }
    }
    
    func assertNoErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let errorLabel =
             app.staticTexts[
                "LoginError"
                //"Нет такого пользователя. Попробуйте другие данные"
            ]
                
            let isFound = errorLabel.waitForExistence(timeout: 5)
            
            XCTAssertFalse(isFound,
                           "Появилась ошибка: \(errorLabel.label)",
                          file: file, line: line)
        }
    }
    
    func navigateToRegistrationScreen() {
        XCTContext.runActivity(named: "Переход на экран регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    func verifyScreenTitle(_ title: String, timeout: TimeInterval = 2) {
        XCTContext.runActivity(named: "Проверяю заголовок экрана: \(title)") { _ in
            let screenTitle = app.staticTexts[title]
            waitForElement(screenTitle, timeout: timeout, message: "The '\(title)' title did not appear on the screen.")
        }
    }
}
