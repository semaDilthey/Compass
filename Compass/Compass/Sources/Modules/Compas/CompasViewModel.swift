//
//  CompasViewModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Foundation
import Combine

protocol ICompasViewModel : AnyObject {
    var location : PassthroughSubject<String, Never> { get }
    var direction : PassthroughSubject<String, Never> { get }
    var heading : PassthroughSubject<Int, Never> { get set }
}

final class CompasViewModel : ICompasViewModel {
    
    //MARK: - Properties
    
    private let locationService : ILocationService
   
    private var cancelables: Set<AnyCancellable> = []
    
    //MARK: - Init
    
    init(locationService: ILocationService = LocationService()) {
        self.locationService = locationService
        bind()
    }
    
    //MARK: - Public properties
    
    public var location = PassthroughSubject<String, Never>()
    public var direction = PassthroughSubject<String, Never>()
    public var heading = PassthroughSubject<Int, Never>()
    

    //MARK: - Private methods
    
    private func bind() {
        
        locationService.didUpdateHeading.sink { heading in
            self.heading.send(Int(heading))
            guard let direction = Direction(azimuth: heading)?.rawValue else { return }
            self.direction.send(direction)
        }.store(in: &cancelables)

        self.locationService.didUpdateLocation.sink { location in
            self.location.send(location)
        }.store(in: &cancelables)
    }
    
}
