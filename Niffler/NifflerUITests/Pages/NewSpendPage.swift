import XCTest

class NewSpendPage: BasePage {
    @discardableResult
    func inputAmount(_ amount: String) -> Self {
        XCTContext.runActivity(named: "Ввожу сумму: \(amount)") { _ in
            let amountField = app.textFields["amountField"]
            waitForElement(amountField, message: "'amountField' field was not found.")
            amountField.tap()
            amountField.typeText(amount)
        }
        return self
    }
    
    func inputDescription(_ title: String) -> Self {
        XCTContext.runActivity(named: "Ввожу описание траты: \(title)") { _ in
            let descriptionField = app.textFields["descriptionField"]
            waitForElement(descriptionField, message: "'descriptionField' field was not found.")
            descriptionField.tap()
            descriptionField.typeText(title)
        }
        return self
    }
    
    func pressAddSpend() {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Add' для сохранения траты") { _ in
            let addButton = app.buttons["Add"]
            waitForElement(addButton, message: "'Add' button did not appear.")
            addButton.tap()
        }
    }
    
    @discardableResult
    func fillCategoryName(in modal: XCUIElement, _ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Ввожу название категории: \(categoryName)") { _ in
            let categoryField = modal.textFields["Name"]
            waitForElement(categoryField, message: "'Name' field was not found in the modal window.")
            categoryField.tap()
            categoryField.typeText(categoryName)
        }
        return self
    }
    
    func pressAddCategoryButton(in container: XCUIElement, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Add' в модальном окне 'Add Category'") { _ in
            let addCategoryButton = container.buttons["Add"]
            waitForElement(addCategoryButton, message: "'Add' button in the modal window did not appear.", file: file, line: line)
            XCTAssertTrue(addCategoryButton.isHittable, "'Add' button is not tappable.", file: file, line: line)
            addCategoryButton.tap()
        }
    }
    
    func addNewCategory(_ categoryName: String = "Рыбалка") -> Self {
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
        return self
    }
    
    func verifyNewCategoryButtonIsVisibleAndTappable(file: StaticString = #file, line: UInt = #line) {
        let newCategoryButton = app.buttons["+ New category"]
        waitForElement(newCategoryButton, timeout: 5, message: "'+ New category' button did not appear.", file: file, line: line)
        
        XCTAssertTrue(newCategoryButton.exists, "'+ New category' button is not visible.", file: file, line: line)
        XCTAssertTrue(newCategoryButton.isHittable, "'+ New category' button is not tappable.", file: file, line: line)
    }
}
