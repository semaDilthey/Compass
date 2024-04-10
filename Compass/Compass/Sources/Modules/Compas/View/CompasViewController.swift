//
//  CompasViewController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit
import Combine

fileprivate enum Constants {
    
    enum FontSize {
        static let title : CGFloat = 24
        static let subtitle : CGFloat = 20
    }
    
    enum Offset {
        /// Множитель вью компаса относительно ширины родителя
        static let compasMultiplier : CGFloat = 0.7
    }
    
}

final class CompasViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel : ICompasViewModel
    private var cancelables: Set<AnyCancellable> = []
    
    //MARK: - Init
    
    init(viewModel: ICompasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    /// Блок с серчФильдом. Имеет делегат SearchViewDelegate реализованный в расширении этого контроллера
    private lazy var searchView = SearchView()
    
    /// Отображение текущей локации пользователя
    private let location = UILabel()
    
    /// Отображение направления [N, S, W, E, NW, etc...]
    private let direction = UILabel()
    
    /// Градусы 0...360
    private let radians = UILabel()
    
    /// Отображение компаса
    private let compasView = CompasView()

    //MARK: - Private methods
    
    private func configSearchView() {
        searchView.delegate = self
    }
    
    /// Настраивает внешность для всего вью в зависимости от выбранной CompasAppearance
    private func configView(with appearance: CompasAppearance) {
        configLabels(with: appearance)
        compasView.setupView(with: appearance)
    }
    
    private func configLabels(with appearance: CompasAppearance) {
        for label in [location, radians, direction] {
            label.textColor = appearance.colorScheme.color
            if label == location {
                label.font = UIFont.systemFont(ofSize: Constants.FontSize.title, weight: .bold)
            } else {
                label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .semibold)
            }
        }
    }
}

extension CompasViewController {
    
    override func configureComponents() {
        super.configureComponents()
        configView(with: viewModel.getAppearance())
        configSearchView()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        addNavBarItem(at: .center, title: "Получение данных...")
        addNavBarItem(at: .right(type: .button(image: C.Images.settings)), title: nil)
    }
    
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(searchView)
        view.addSubview(compasView)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        compasView.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [radians, direction])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = C.Offset.medium
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 60),
            
            compasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compasView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            compasView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.Offset.compasMultiplier),
            compasView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.Offset.compasMultiplier),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: compasView.bottomAnchor, constant: C.Offset.medium*8)
        ])
    }
    
    override func bind() {
        super.bind()

        viewModel.location
            .throttle(for: .seconds(1.5), scheduler: DispatchQueue.main, latest: true)
            .sink { location in
            self.location.text = location
            self.addNavBarItem(at: .center, title: location)
        }.store(in: &cancelables)
        
        viewModel.direction
            .sink { direction in
            self.direction.text = direction
        }.store(in: &cancelables)
        
        viewModel.heading.sink { heading in
            self.radians.text = String(heading) + " " + C.Strings.radians
            UIView.animate(withDuration: 0.1) {
                self.compasView.rotate(for: CGFloat(heading))
            }
        }.store(in: &cancelables)
        
        viewModel.compasModel.sink { [weak self] compasModel in
            DispatchQueue.main.async {
                self?.configView(with: compasModel.appearance)
            }
        }.store(in: &cancelables)
    }
    
    override func navBarRightItemHandler() {
        super.navBarRightItemHandler()
        viewModel.presentSettings(sender: self, navController: navigationController)
    }

}

extension CompasViewController : SearchViewDelegate {
    
    func searchCity(city: String) {
        viewModel.searchDistanceTo(city: city)
        viewModel.destinationPointDistance
            // throttle для работы с геокодером, иначе запросы идут слишком часто
            .throttle(for: .seconds(1.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] distance in
            self?.searchView.setCity(name: city, distance: distance)
        }.store(in: &cancelables)
    }
    
}

extension CompasViewController : SettingsDelegate {
    
    func changeColorScheme(toLight: Bool) {
        viewModel.setAppearance(isLight: toLight)
    }
    
}
