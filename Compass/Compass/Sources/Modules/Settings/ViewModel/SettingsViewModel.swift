//
//  SettingsViewModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import Foundation
import UIKit
import Combine

protocol ISettingsTable {
    func numberOfRows() -> Int
    func getTableModel(at indexPath: IndexPath) -> ISettingsTableCellModel?
    
    /// Обрабатывает изменения свитчей на экране настроек и отправляет на CompasVC
    /// - Parameters:
    ///   - sender: Отправитель изменений - SettingsViewController
    ///   - cell: Ячейка в которой произошли изменения
    ///   - indexPath: Индекс в таблице
    func sendChangesToRoot(sender: SettingsViewController, from cell: UITableViewCell, at indexPath: IndexPath)
}

protocol ISettingsViewModel : AnyObject, ISettingsTable {
    func setSettingsData()
}

final class SettingsViewModel : ISettingsViewModel {
    
    //MARK: - Properties
    
    private var dataSource : [ISettingsDataSource] = []
    var cancellables : Set<AnyCancellable> = []

    
    /// Заполнение dataSouce объектами типа ISettingsDataSource из enumа SettingsDataSource
    public func setSettingsData() {
        SettingsDataSource.allCases.map { settings in
            dataSource.append(SettingsDataSourceImlp(icon: settings.icon, title: settings.title, option: settings.option))
        }
    }
    
    public func numberOfRows() -> Int {
        return dataSource.count
    }
    
    public func getTableModel(at indexPath: IndexPath) -> ISettingsTableCellModel? {
        guard indexPath.row < dataSource.count else { return nil }
        let icon = dataSource[indexPath.row].icon
        let title = dataSource[indexPath.row].title
        return SettingsTableCellModel(icon: icon, title: title)
    }
    
    public func sendChangesToRoot(sender: SettingsViewController, from cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? SettingsCell {
            switch indexPath.row {
            case 0:
                cell.isSwitcherOn.sink { value in
                    sender.delegate?.changeColorScheme(toLight: value)
                }.store(in: &self.cancellables)
            default:
                print("oopsie")
            }
        }
    }
}
