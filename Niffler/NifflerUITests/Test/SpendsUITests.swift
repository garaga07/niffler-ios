import XCTest

final class SpendsUITests: XCTestCase {
    
    func testSpendListIsEmptyAfterRegistration() throws {
        XCTContext.runActivity(named: "Тест: пустой список трат после регистрации нового пользователя") { _ in
            let app = XCUIApplication()
            let loginPage = LoginPage(app: app)
            let registerPage = RegisterPage(app: app)
            let spendsPage = SpendsPage(app: app)
            
            // Arrange
            loginPage.launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
            registerPage.registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
            registerPage.tapLogInButtonInModal()
            loginPage.pressLoginButton()
            
            // Assert
            spendsPage.verifySpendListIsEmpty()
        }
    }
    
    func testAddNewSpendWithNewCategory() throws {
        XCTContext.runActivity(named: "Тест: добавление траты с новой категорией") { _ in
            let app = XCUIApplication()
            let loginPage = LoginPage(app: app)
            let registerPage = RegisterPage(app: app)
            let spendsPage = SpendsPage(app: app)
            let newSpendPage = NewSpendPage(app: app)
            
            // Arrange
            loginPage.launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
            registerPage.registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
            registerPage.tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
            newSpendPage.inputAmount("1000")
            newSpendPage.inputDescription("Удочки")
            newSpendPage.pressAddSpend()
            
            // Assert
            spendsPage.assertNewSpendIsShown(title: "Удочки")
        }
    }
    
    func testAddNewSpendWithExistingCategory() throws {
        XCTContext.runActivity(named: "Тест: добавление траты с существующей категорией") { _ in
            let app = XCUIApplication()
            let loginPage = LoginPage(app: app)
            let spendsPage = SpendsPage(app: app)
            let newSpendPage = NewSpendPage(app: app)
            
            // Arrange
            loginPage.launchAppWithoutLogin()
            
            // Act
            loginPage.login(userName: "Duck123", password: "12345")
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
            newSpendPage.inputAmount("300")
            let randomDescription = RandomDataUtils.generateRandomString(length: 10)
            newSpendPage.inputDescription(randomDescription)
            newSpendPage.pressAddSpend()
            
            // Assert
            spendsPage.assertNewSpendIsShown(title: randomDescription)
        }
    }
    
    func testVerifyCategoryInProfileAfterAddingNewSpend() throws {
        XCTContext.runActivity(named: "Тест: проверка отображения новой категории в профиле после добавления траты") { _ in
            let app = XCUIApplication()
            let loginPage = LoginPage(app: app)
            let registerPage = RegisterPage(app: app)
            let spendsPage = SpendsPage(app: app)
            let newSpendPage = NewSpendPage(app: app)
            let profilePage = ProfilePage(app: app)
            
            
            // Arrange
            loginPage.launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
            registerPage.registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
            registerPage.tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
            newSpendPage.inputAmount("1000")
            newSpendPage.inputDescription("Удочки")
            newSpendPage.pressAddSpend()
            profilePage.goToProfileScreen()
            
            // Assert
            profilePage.verifyCategory("Рыбалка")
        }
    }
    
    func testDeletedCategoryIsNotShownInSpendScreen() throws {
        XCTContext.runActivity(named: "Тест: проверка, что удалённая категория не отображается на экране добавления новой траты") { _ in
            let app = XCUIApplication()
            let loginPage = LoginPage(app: app)
            let registerPage = RegisterPage(app: app)
            let spendsPage = SpendsPage(app: app)
            let newSpendPage = NewSpendPage(app: app)
            let profilePage = ProfilePage(app: app)
            
            // Arrange
            loginPage.launchAppWithoutLogin()
            let uniqueUserName = RandomDataUtils.generateUniqueUserName()
            
            // Act
            loginPage.navigateToRegistrationScreen()
            registerPage.registerUser(userName: uniqueUserName, password: "12345", confirmPassword: "12345")
            registerPage.tapLogInButtonInModal()
            loginPage.pressLoginButton()
            spendsPage.addSpend()
            newSpendPage.addNewCategory()
            newSpendPage.inputAmount("1000")
            newSpendPage.inputDescription("Удочки")
            newSpendPage.pressAddSpend()
            profilePage.goToProfileScreen()
            profilePage.deleteCategory("Рыбалка")
            profilePage.tapCloseButton()
            spendsPage.addSpend()
            
            // Assert
            newSpendPage.verifyNewCategoryButtonIsVisibleAndTappable()
        }
    }
}
