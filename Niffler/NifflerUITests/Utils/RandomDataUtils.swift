//
//  RandomDataUtils.swift
//  Niffler
//
//  Created by team on 11.12.2024.
//
import XCTest

class RandomDataUtils {
    static func generateUniqueUserName() -> String {
        XCTContext.runActivity(named: "Генерация уникального имени пользователя") { _ in
            let uniqueUserName = "user\(Int(Date().timeIntervalSince1970))"
            XCTContext.runActivity(named: "Сгенерирован логин: \(uniqueUserName)") { _ in }
            return uniqueUserName
        }
    }
    
    static func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}
