import XCTest

class LoginPage: BasePage {
    
    func login(userName: String, password: String) {
        XCTContext.runActivity(named: "Выполняю вход с именем пользователя '\(userName)' и паролем") { _ in
            fillUserName(userName)
            fillPassword(password)
            pressLoginButton()
        }
    }
    
    @discardableResult
    func fillUserName(_ userName: String) -> Self {
        XCTContext.runActivity(named: "Ввожу имя пользователя: \(userName)") { _ in
            let userNameTextField = app.textFields["userNameTextField"]
            waitForElement(userNameTextField, message: "The 'userNameTextField' did not appear on the screen.")
            userNameTextField.tap()
            userNameTextField.typeText(userName)
        }
        return self
    }
    
    @discardableResult
    func fillPassword(_ password: String) -> Self {
        XCTContext.runActivity(named: "Ввожу пароль: \(password)") { _ in
            let passwordTextField = app.secureTextFields["passwordTextField"]
            waitForElement(passwordTextField, message: "The 'passwordTextField' did not appear on the screen.")
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
        return self
    }
    
    func pressLoginButton(file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Жму кнопку логина") { _ in
            let loginButton = app.buttons["loginButton"]
            waitForElement(loginButton, message: "Login button did not appear on the login screen.", file: file, line: line)
            XCTAssertTrue(loginButton.isHittable, "Login button is not tappable.", file: file, line: line)
            loginButton.tap()
        }
    }
    
    func assertIsLoginErrorShown(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let isFound = app.staticTexts["LoginError"]
                .waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Не нашли сообщение о неправильном логине",
                          file: file, line: line)
        }
        return self
    }
    
    func assertNoErrorShown(file: StaticString = #filePath, line: UInt = #line) -> Self {
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
        return self
    }
    
    @discardableResult
    func navigateToRegistrationScreen() -> RegisterPage {
        XCTContext.runActivity(named: "Переход на экран регистрации") { _ in
            app.staticTexts["Create new account"].tap()
        }
        return RegisterPage(app: app)
    }
    
    func verifyScreenTitle(_ title: String, timeout: TimeInterval = 2) {
        XCTContext.runActivity(named: "Проверяю заголовок экрана: \(title)") { _ in
            let screenTitle = app.staticTexts[title]
            waitForElement(screenTitle, timeout: timeout, message: "The '\(title)' title did not appear on the screen.")
        }
    }
}
