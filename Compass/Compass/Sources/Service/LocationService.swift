//
//  LocationService.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Foundation
import CoreLocation

//MARK: - Interface

protocol ILocationService : AnyObject {
    var didUpdateHeading : ((CLLocationDirection)->Void)? { get set }
    var didUpdateLocation: ((String) -> Void)? { get set }
}

//MARK: - LocationServiceClass

final class LocationService : NSObject, ILocationService {
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()

    public var didUpdateHeading : ((CLLocationDirection)->Void)?
    public var didUpdateLocation: ((String) -> Void)?
    
    //MARK: - Initializtion
    
    override init() {
        super.init()
        configLocationManager()
    }
    
    deinit {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - Private methods
    
    private func configLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
        }
    }
    
    private func decodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("Ошибка при получении местоположения: \(error?.localizedDescription ?? LocationError.wrongLocation.localizedDescription)")
                return
            }
            
            if let address = placemark.name {
                self?.didUpdateLocation?(address)
            }
        }
    }

}

//MARK: - CLLocationManagerDelegate

extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading?(newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        decodeLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
}
