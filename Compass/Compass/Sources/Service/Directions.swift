//
//  Directions.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Foundation

enum Direction: String, CaseIterable {
    case north = "N"
    case northEast = "NE"
    case east = "E"
    case southEast = "SE"
    case south = "S"
    case southWest = "SW"
    case west = "W"
    case northWest = "NW"
    case wrong = "Cant get your azimuth"
    
    /// True north-based azimuths
    ///
    init?(azimuth: Double) {
        switch azimuth  {
        case 337.5...360, 0..<22.5:
           self = .north
        case 22.5..<67.5:
           self = .northEast
        case 67.5..<112.5:
           self = .east
        case 112.5..<157.5:
           self = .southEast
        case 157.5..<202.5:
           self = .south
        case 202.5..<247.5:
           self = .southWest
        case 247.5..<292.5:
           self = .west
        case 292.5..<337.5:
           self = .northWest
        default:
           self = .wrong
        }
    }
    
}
