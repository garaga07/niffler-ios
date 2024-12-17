//
//  TestCase.swift
//  Niffler
//
//  Created by team on 17.12.2024.
//
import XCTest

class TestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp(){
        super.setUp()
        app = XCUIApplication()
    }
    
    func launchAppWithoutLogin(){
        XCTContext.runActivity(named: "Запуск приложения") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    override func tearDown() {
        app = nil
        
        loginPage = nil
        spendsPage = nil
        registerPage = nil
        newSpendPage = nil
        profilePage = nil
        
        super.tearDown()
    }
    
    lazy var loginPage: LoginPage! = LoginPage(app: app)
    lazy var spendsPage: SpendsPage! = SpendsPage(app: app)
    lazy var registerPage: RegisterPage! = RegisterPage(app: app)
    lazy var newSpendPage: NewSpendPage! = NewSpendPage(app: app)
    lazy var profilePage: ProfilePage! = ProfilePage(app: app)
}
