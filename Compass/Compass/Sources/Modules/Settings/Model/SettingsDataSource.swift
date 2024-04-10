//
//  SettingsDataSource.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import UIKit

/// Как по мне довольно гибкий вариант для настройки объектов настроек и настроек таблицы. Лего добавлять и убирать объекты работая только с енамом
enum SettingsDataSource: CaseIterable {
    case settings1
    case settings2
    case settings3
    case settings4
    
    var title : String {
        switch self {
        case .settings1:
            return "Переключить тему"
        case .settings2:
            return "Настройка 2"
        case .settings3:
            return "Настройка 3"
        case .settings4:
            return "Настройка 4"
        }
    }
    
    var icon : UIImage {
        switch self {
        case .settings1:
            return C.Images.settings!
        case .settings2:
            return C.Images.settings!
        case .settings3:
            return C.Images.settings!
        case .settings4:
            return C.Images.settings!
        }
    }
    
    /// Любая другая настройка которая нам может понадобиться
    var option : SettingsOption {
        switch self {
        case .settings1:
            return SettingsOption()
        case .settings2:
            return SettingsOption()
        case .settings3:
            return SettingsOption()
        case .settings4:
            return SettingsOption()
        }
    }
}



protocol ISettingsDataSource {
    var icon : UIImage { get }
    var title : String { get }
    var option : SettingsOption { get }
}

struct SettingsDataSourceImlp: ISettingsDataSource {
    var icon: UIImage
    
    var title: String
    
    var option: SettingsOption
}

struct SettingsOption {
    
}
