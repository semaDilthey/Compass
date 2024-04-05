//
//  CompasModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Foundation

protocol ICompasModel {
    var direction : String? { get set }
    var location : String? { get set }
}

struct CompasModel : ICompasModel {
    var direction: String?
    
    var location: String?
    
    init(direction: String?, location: String?) {
        if direction == nil {
            self.location = location
        }else if location == nil {
            self.direction = direction
            self.location = "No location"
        }
    }
}
