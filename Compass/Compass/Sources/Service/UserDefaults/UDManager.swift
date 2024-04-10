//
//  UDManager.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case isRedAppearance = "isRedAppearance"
    
    var key : String {
        return self.rawValue
    }
}

// TODO: Сервис сделал, но реализовать не успеваю. Сохранение свитчей настроек в ЮД дабы оно не слетало после каждого перехода с экрана
final class UDManager : NSObject {
    
    static let shared = UDManager()

    private override init() {
        userDefaults = UserDefaults.standard
    }

    private let userDefaults : UserDefaults

    // метод для проверки, является ли цветовая схема красной
    func isRedAppearance() -> Bool {
        return userDefaults.bool(forKey: UserDefaultsKey.isRedAppearance.key)
    }

    func setRedAppearance(value: Bool) {
        userDefaults.setValue(value, forKey: UserDefaultsKey.isRedAppearance.key)
    }
    
}
