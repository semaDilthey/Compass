//
//  LocationService.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Foundation
import CoreLocation
import Combine

//MARK: - Interface

protocol ILocationService : AnyObject {
    /// Объект с обновляемой локацией пользователя
    var didUpdateLocation : PassthroughSubject<String, Never> { get set }
    
    /// Обновляет направление 'heading'-а телефона для локации по компасу
    /// см. метод "func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)"
    var didUpdateHeading : PassthroughSubject<CLLocationDirection, Never> { get set }
    
    /// Метод для поиска локации, расстояние до которой будем считать.
    /// - Parameter adres: Параметр, который будет заполняться из поля searchField и уходить в CLGeocoder()
    func searchForPlace(with adress: String)
    
    /// Дистанция до места, которые мы ищем. Исчисляется от нашей текущей локации
    /// См. метод "func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])"
    var distanceToPlace: AnyPublisher<CLLocationDistance?, Never> { get }
}

//MARK: - LocationServiceClass

final class LocationService : NSObject, ILocationService {
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var _distanceToPlace = PassthroughSubject<CLLocationDistance?, Never>()
    
    public var didUpdateLocation = PassthroughSubject<String, Never>()
    public var didUpdateHeading = PassthroughSubject<CLLocationDirection, Never>()
    
    var distanceToPlace: AnyPublisher<CLLocationDistance?, Never> {
        _distanceToPlace.eraseToAnyPublisher()
    }
    
    var placemark : CLPlacemark?
    //MARK: - Initializtion
    
    override init() {
        super.init()
        configLocationManager()
    }
    
    deinit {
        deinitLocationMngr()
    }
    
    public func searchForPlace(with adress: String) {
        let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(adress) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                guard let placemark = placemarks?.first else {
                    print("Ошибка при получении местоположения желаемой точки: \(error?.localizedDescription ?? LocationError.wrongLocation.localizedDescription)")
                    return
                }
                // Возвращает геоадрес для desired location
                self.placemark = placemark

            }
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
    
    private func deinitLocationMngr() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    /// Декодирует локацию пользователя и отображает ее на экране.
    /// - Parameter location: Последняя локация пользователя, см. метод "func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])"
    private func decodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let placemark = placemarks?.first else {
                    print("Ошибка при получении местоположения: \(error?.localizedDescription ?? LocationError.wrongLocation.localizedDescription)")
                    return
                }
                
                if let address = placemark.name {
                    self?.didUpdateLocation.send(address)
                }
                
                guard let desiredPlacemark = self?.placemark else {
                    print("No placemark found")
                    return
                }
                
                //                // Отправляет расстояние от нашей локации до точки навигации
                if let currentLocation = self?.locationManager.location {
                    self?._distanceToPlace.send(currentLocation.distance(from: desiredPlacemark.location ?? CLLocation()))
                   }
            }
        }
    }

}

//MARK: - CLLocationManagerDelegate

extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading.send(newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        decodeLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
}
