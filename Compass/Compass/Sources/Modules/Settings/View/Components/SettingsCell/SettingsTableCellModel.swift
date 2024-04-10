//
//  SettingsTableModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import UIKit

protocol ISettingsTableCellModel {
    var icon : UIImage { get }
    var title : String { get }
}

struct SettingsTableCellModel : ISettingsTableCellModel {
    var icon: UIImage
    
    var title: String
}
