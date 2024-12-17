import XCTest

final class SpendsUITests: TestCase {
    
    func testSpendListIsEmptyAfterRegistration() throws {
        XCTContext.runActivity(named: "Тест: пустой список трат после регистрации нового пользователя") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
                .registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
                .tapLogInButtonInModal()
            loginPage.pressLoginButton()
            
            // Assert
            spendsPage.verifySpendListIsEmpty()
        }
    }
    
    func testAddNewSpendWithNewCategory() throws {
        XCTContext.runActivity(named: "Тест: добавление траты с новой категорией") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
                .registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
                .tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
                .inputAmount("1000")
                .inputDescription("Удочки")
                .pressAddSpend()
            
            // Assert
            spendsPage.assertNewSpendIsShown(title: "Удочки")
        }
    }
    
    func testAddNewSpendWithExistingCategory() throws {
        XCTContext.runActivity(named: "Тест: добавление траты с существующей категорией") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            
            // Act
            loginPage.login(userName: "Duck123", password: "12345")
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
                .inputAmount("300")
            let randomDescription = RandomDataUtils.generateRandomString(length: 10)
            newSpendPage.inputDescription(randomDescription)
                .pressAddSpend()
            
            // Assert
            spendsPage.assertNewSpendIsShown(title: randomDescription)
        }
    }
    
    func testVerifyCategoryInProfileAfterAddingNewSpend() throws {
        XCTContext.runActivity(named: "Тест: проверка отображения новой категории в профиле после добавления траты") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
                .registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
                .tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
                .inputAmount("1000")
                .inputDescription("Удочки")
                .pressAddSpend()
            profilePage.goToProfileScreen()
            
            // Assert
                .verifyCategory("Рыбалка")
        }
    }
    
    func testDeletedCategoryIsNotShownInSpendScreen() throws {
        XCTContext.runActivity(named: "Тест: проверка, что удалённая категория не отображается на экране добавления новой траты") { _ in
            
            // Arrange
            launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
                .registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
                .tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
                .inputAmount("1000")
                .inputDescription("Удочки")
                .pressAddSpend()
            profilePage.goToProfileScreen()
                .deleteCategory("Рыбалка")
                .tapCloseButton()
            spendsPage.addSpend()
            
            // Assert
            newSpendPage.verifyNewCategoryButtonIsVisibleAndTappable()
        }
    }
}
