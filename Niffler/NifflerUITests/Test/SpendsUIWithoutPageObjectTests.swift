//
//  SpendsUIWithoutPageObjectTests.swift
//  Niffler
//
//  Created by team on 09.12.2024.
//

import XCTest

final class SpendsUIWithoutPageObjectTests: XCTestCase {
    var app: XCUIApplication!
    
    func testSpendListIsEmptyAfterRegistration() throws {
           XCTContext.runActivity(named: "Тест: пустой список трат после регистрации нового пользователя") { _ in
               // Arrange
               launchApp()
               let uniqueUserName = generateUniqueUserName()
               
               // Act
               navigateToRegistrationScreen()
               let registrationForm = getRegistrationForm()
               registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345", on: registrationForm)
               tapLogInButtonInModal()
               pressLoginButton()
               
               // Assert
               verifySpendListIsEmpty()
           }
       }
    
    func testAddNewSpendWithNewCategory() throws {
           XCTContext.runActivity(named: "Тест: добавление траты с новой категорией") { _ in
               // Arrange
               launchApp()
               let uniqueUserName = generateUniqueUserName()
               
               // Act
               navigateToRegistrationScreen()
               let registrationForm = getRegistrationForm()
               registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345", on: registrationForm)
               tapLogInButtonInModal()
               pressLoginButton()
               addSpend()
               addNewCategory()
               inputAmount("1000")
               inputDescription("Удочки")
               pressAddSpend()
               
               // Assert
               assertNewSpendIsShown(title: "Удочки")
           }
       }
    
    func testAddNewSpendWithExistingCategory() throws {
        XCTContext.runActivity(named: "Тест: добавление траты с существующей категорией") { _ in
            // Arrange
            launchApp()
            
            // Act
            login(userName: "Duck", password: "12345")
            addSpend()
            addNewCategory()
            inputAmount("300")
            let randomDescription = generateRandomString(length: 10)
            inputDescription(randomDescription)
            pressAddSpend()
            
            // Assert
            assertNewSpendIsShown(title: randomDescription)
        }
    }
    
    // MARK: - Domain Specific Language
    private func launchApp(){
        XCTContext.runActivity(named: "Запуск приложения") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
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
    
    private func pressLoginButton() {
        XCTContext.runActivity(named: "Жму кнопку логина") { _ in
            let loginButton = app.buttons["loginButton"]
            waitForElement(loginButton, message: "Login button did not appear on the login screen.")
            XCTAssertTrue(loginButton.isHittable, "Login button is not tappable.")
            app.buttons["loginButton"].tap()
        }
    }
    
    private func login(userName: String, password: String) {
        XCTContext.runActivity(named: "Выполняю вход с именем пользователя '\(userName)' и паролем") { _ in
            fillUserName(in: app, userName)
            fillPassword(in: app, password)
            pressLoginButton()
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
    
    private func tapLogInButtonInModal(file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Log in' в модальном окне 'Congratulations!'") { _ in
            let modal = app.otherElements.containing(.staticText, identifier: "Congratulations!").firstMatch
            let logInButton = modal.buttons["Log in"]
            
            waitForElement(logInButton,timeout: 2, message: "The 'Log in' button in the modal window did not appear.", file: file, line: line)
            XCTAssertTrue(logInButton.isHittable, "The 'Log in' button is not tappable.", file: file, line: line)
            logInButton.tap()
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
    
    private func verifySpendListIsEmpty(expectedValue: String = "0 ₽") {
        XCTContext.runActivity(named: "Проверяю, что список трат пуст для вновь зарегистрированного пользователя и содержит значение \(expectedValue)") { _ in
            let spendList = app.staticTexts["spendList"]
            waitForElement(spendList, timeout: 3, message: "'spendList' element did not appear.")
            let actualValue = spendList.label
            XCTAssertEqual(
                actualValue,
                expectedValue,
                "The spend list value does not match the expected value."
            )
        }
    }

    private func addSpend() {
        XCTContext.runActivity(named: "Нажимаю кнопку добавления траты") { _ in
            let addSpendButton = app.buttons["addSpendButton"]
            waitForElement(addSpendButton, timeout: 5, message: "'addSpendButton' button did not appear.")
            addSpendButton.tap()
        }
    }

    func inputAmount(_ amount: String) {
        XCTContext.runActivity(named: "Ввожу сумму: \(amount)") { _ in
            let amountField = app.textFields["amountField"]
            waitForElement(amountField, message: "'amountField' field was not found.")
            amountField.tap()
            amountField.typeText(amount)
        }
    }

    func inputDescription(_ title: String) {
        XCTContext.runActivity(named: "Ввожу описание траты: \(title)") { _ in
            let descriptionField = app.textFields["descriptionField"]
            waitForElement(descriptionField, message: "'descriptionField' field was not found.")
            descriptionField.tap()
            descriptionField.typeText(title)
        }
    }

    func pressAddSpend() {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Add' для сохранения траты") { _ in
            let addButton = app.buttons["Add"]
            waitForElement(addButton, message: "'Add' button did not appear.")
            addButton.tap()
        }
    }

    private func fillCategoryName(in modal: XCUIElement, _ categoryName: String) {
        XCTContext.runActivity(named: "Ввожу название категории: \(categoryName)") { _ in
            let categoryField = modal.textFields["Name"]
            waitForElement(categoryField, message: "'Name' field was not found in the modal window.")
            categoryField.tap()
            categoryField.typeText(categoryName)
        }
    }

    private func pressAddCategoryButton(in container: XCUIElement, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Add' в модальном окне 'Add Category'") { _ in
            let addCategoryButton = container.buttons["Add"]
            waitForElement(addCategoryButton, message: "'Add' button in the modal window did not appear.", file: file, line: line)
            XCTAssertTrue(addCategoryButton.isHittable, "'Add' button is not tappable.", file: file, line: line)
            addCategoryButton.tap()
        }
    }

    private func addNewCategory(_ categoryName: String = "Рыбалка") {
        XCTContext.runActivity(named: "Добавляю новую категорию: \(categoryName)") { _ in
            let newCategoryButton = app.buttons["+ New category"]
            waitForElement(newCategoryButton, timeout: 5, message: "'+ New category' button did not appear.")

            if newCategoryButton.isHittable {
                newCategoryButton.tap()
                let modalNewCategory = app.otherElements.containing(.staticText, identifier: "Add category").firstMatch
                fillCategoryName(in: modalNewCategory, categoryName)
                pressAddCategoryButton(in: modalNewCategory)
            } else {
                app.buttons["Select category"].tap()
                app.buttons[categoryName].tap()
            }
        }
    }

    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что новая трата с заголовком '\(title)' отображается в списке") { _ in
            let spendTitle = app.firstMatch
                .scrollViews.firstMatch
                .staticTexts[title].firstMatch

            waitForElement(spendTitle, timeout: 2, message: "Spend with title '\(title)' was not found in the list.")

            XCTAssertTrue(spendTitle.exists, "Spend with title '\(title)' is not displayed in the list.", file: file, line: line)
        }
    }
    
    private func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}
