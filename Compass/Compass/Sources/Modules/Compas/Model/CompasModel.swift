//
//  CompasModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

protocol ICompasModel {
    var appearance : CompasAppearance { get set }
}

//MARK: - Model of configuring CompasView.
/// You can add any property you want to work with
public struct CompasModel : ICompasModel {
    var appearance : CompasAppearance
    
    init(appearance: CompasAppearance = CompasAppearance()) {
        self.appearance = appearance
    }
}

struct CompasAppearance {
    var diskColor : DiskColor
    var colorScheme : ColorScheme
        
    init(diskColor: DiskColor = .black, colorScheme: ColorScheme = .white ) {
        self.diskColor = diskColor
        self.colorScheme = colorScheme
    }
}


enum DiskColor {
    case black
    case green
    
    var color : UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .green:
            return UIColor.green
        }
    }
}


enum ColorScheme {
    case white
    case red
    case blue
    case pink
    
    var color : UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .pink:
            return UIColor.systemPink
        }
    }
}
