//
//  +CGFloat.swift
//  Compass
//
//  Created by Семен Гайдамакин on 05.04.2024.
//

import Foundation

extension CGFloat {
    
    var inRadians : CGFloat {
        self * .pi / 180
    }
    
    func roundedKilometers(toPlaces places: Int) -> CGFloat {
        let kilometers = self / 1000.0
        let roundedKilometers = (kilometers * pow(10.0, CGFloat(places))).rounded() / pow(10.0,CGFloat(places))
        return roundedKilometers
    }
}
