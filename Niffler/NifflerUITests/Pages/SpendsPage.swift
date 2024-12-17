import XCTest

class SpendsPage: BasePage {
    func verifySpendListIsEmpty(expectedValue: String = "0 ₽") {
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
    
    func addSpend() {
        XCTContext.runActivity(named: "Нажимаю кнопку добавления траты") { _ in
            let addSpendButton = app.buttons["addSpendButton"]
            waitForElement(addSpendButton, timeout: 5, message: "'addSpendButton' button did not appear.")
            addSpendButton.tap()
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
}
