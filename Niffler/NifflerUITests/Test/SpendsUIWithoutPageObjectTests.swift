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
}
