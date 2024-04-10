//
//  CompasViewModel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import Combine
import Foundation
import UIKit

protocol CompasVMLocationProtocol {
    /// Получаем и впоследствии передаем локацию пользователя
    var location : PassthroughSubject<String, Never> { get }
    /// Направление компаса [N,S,E,W,etc]
    var direction : PassthroughSubject<String, Never> { get }
    /// heading телефона по направлению на N
    var heading : PassthroughSubject<Int, Never> { get set }
    /// Расстояние до точки, в которую хотим попасть
    var destinationPointDistance : PassthroughSubject<CGFloat, Never> { get set }
    /// Вызывает метод "searchForPlace(with: city)" у locationManager. Сам вызывается в расширеннии контроллера
    /// - Parameter city: Введеный в серчБаре город
    func searchDistanceTo(city: String)
    func presentSettings(sender: CompasViewController, navController: UINavigationController?)
}

protocol CompasVMAppearanceProtocol {
    /// Получаем текущую актуальную внешность компаса
    func getAppearance() -> CompasAppearance
    func setAppearance(isLight: Bool)
    /// Оперерируем моделью компаса для настройки и обновления всех вьюх. Пока это влияет сугубо на визуал
    var compasModel : CurrentValueSubject<CompasModel, Never> { get set }
}

protocol ICompasViewModel : AnyObject, CompasVMLocationProtocol, CompasVMAppearanceProtocol {}

//MARK: - CompasViewModel Implementation

final class CompasViewModel : ICompasViewModel {
    
    //MARK: - Properties
    
    private let locationService : ILocationService
    private var _compasModel : ICompasModel

    private var cancelables: Set<AnyCancellable> = []
    
    //MARK: - Init
    
    init(locationService: ILocationService = LocationService(), _compasModel : ICompasModel = CompasModel()) {
        self.locationService = locationService
        self._compasModel = _compasModel
        bind()
    }
    
    //MARK: - Public properties
    
    public var location = PassthroughSubject<String, Never>()
    public var direction = PassthroughSubject<String, Never>()
    
    public var heading = PassthroughSubject<Int, Never>()
    public var destinationPointDistance = PassthroughSubject<CGFloat, Never>()
    
    public var compasModel = CurrentValueSubject<CompasModel, Never>(.init())
    
    //MARK: - Methods
    
    public func searchDistanceTo(city: String)  {
        locationService.searchForPlace(with: city)
    }
    
    public func presentSettings(sender: CompasViewController, navController: UINavigationController?) {
        guard let navController else { return }
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        vc.delegate = sender
        navController.pushViewController(vc, animated: false)
    }
    
    public func getAppearance() -> CompasAppearance {
        return _compasModel.appearance
    }
    
    public func setAppearance(isLight: Bool) {
        print("Сейчас темы светла? \(isLight)")
        if isLight {
            _compasModel.appearance = CompasAppearance(colorScheme: .red)
            compasModel.send(_compasModel as! CompasModel)
        } else {
            _compasModel.appearance = CompasAppearance(colorScheme: .white)
            compasModel.send(_compasModel as! CompasModel)
        }
    }
    

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
        
        
        locationService.distanceToPlace.sink { locationDistance in
            guard let locationDistance else {
                print("Error: // Cant get ditance to desired location")
                return
            }
            let roundedDistance = CGFloat(locationDistance).roundedKilometers(toPlaces: 3)
            self.destinationPointDistance.send(roundedDistance)
        }.store(in: &cancelables)
    }
    
}
