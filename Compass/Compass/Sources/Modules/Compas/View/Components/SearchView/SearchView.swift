//
//  SearchView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 09.04.2024.
//

import UIKit
import Foundation

protocol SearchViewDelegate : AnyObject {
    func searchCity(city: String)
}

fileprivate enum Constants {
    static let buttonSide: CGFloat = 60
    static let searchImage = UIImage(named: "search")
    static let tintColor = UIColor.white
}

final class SearchView : BaseView {
    
    //MARK: - Properties
    weak var delegate : SearchViewDelegate?
    
    /// Свойство для определения активного состояния searchBar.
    /// isSearching = true при нажатии кнопки и раскрытии searchBar.
    /// isSearching = false когда жмем энтер в серчбаре
    private var isSearching: Bool = false {
        didSet {
            if isSearching {
                setIsSearching()
            } else {
                setNotSearching()
            }
            updateSearchingConstraints()
            animateSearchBarWidthChange()
        }
    }
    
    /// Свойство для хранения ширины searchBar и searchButton
    private var searchBarWidth: CGFloat = 0
    private var searchButtonWidth: CGFloat = 0
    
    //MARK: - UI Elementes

    private let searchButton = UIButton()
    private let locationLabel = UILabel()
    private lazy var searchBar = UISearchBar()
    
    //MARK: - Public methods

    /// Установка лейбла места, расстоян до которого мы ищем
    public func setCity(name: String, distance: CGFloat) {
        let distance = "\(distance) km"
        let destination = "to \(name)"
        locationLabel.text = distance + " " + destination
    }
    
    /// Останавливает редактирование извне. В нашем случае по тапу в любую точку экрана
    public func stopEditing() {
        searchBar.resignFirstResponder()
        isSearching = false
        searchBar.text = nil
    }

    //MARK: - Private methods
    // Conifuring animations
    
    /// отрабатывает в обсервере isSearching = true
    private func setIsSearching() {
        searchBar.becomeFirstResponder()
        searchButtonWidth = 0
        searchBarWidth = frame.width - C.Offset.medium*2
        changeAlpha(view: searchBar, alpha: 1)
        changeAlpha(view: locationLabel, alpha: 0)
    }
    
    /// отрабатывает в обсервере isSearching = false
    private func setNotSearching() {
        searchBar.resignFirstResponder()
        searchBarWidth = 0
        searchButtonWidth = frame.height*0.75
        changeAlpha(view: searchBar, alpha: 0)
        changeAlpha(view: locationLabel, alpha: 1)
    }
    
    /// Меняет прозрачность компонентов, необходимо для плавности анимации
    private func changeAlpha(view: UIView, alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            view.alpha = alpha
        }
    }
    
    /// Метод для анимации изменения ширины searchBar
    private func animateSearchBarWidthChange() {
      UIView.animate(withDuration: 0.5) {
          self.layoutIfNeeded()
      }
    }
    
    private func updateSearchingConstraints() {
        // Удаление предыдущих констрейнтов
        NSLayoutConstraint.deactivate(searchBar.constraints)
        NSLayoutConstraint.deactivate(searchButton.constraints)

        // Создание новых констрейнтов
        NSLayoutConstraint.activate([
            // searchBar constraints
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.Offset.medium),
            searchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth), // Используем searchBarWidth для ширины
            
            // searchButton constraints
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.Offset.medium),
            searchButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            searchButton.widthAnchor.constraint(equalToConstant: searchButtonWidth) // Используем searchBarWidth для ширины
        ])
    }
    
    /// SettingUP UI Elements
    private func configSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = Constants.tintColor
        searchBar.keyboardType = .alphabet
    }
    
    private func configCityLabel() {
        locationLabel.font = UIFont.systemFont(ofSize: 24)
        locationLabel.textColor = Constants.tintColor
    }
    
    private func configSearchButton() {
        searchButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        searchButton.setImage(Constants.searchImage, for: .normal)
        searchButton.contentMode = .scaleAspectFit
        searchButton.tintColor = Constants.tintColor
    }
    
    //MARK: - @objc methods

    @objc private func buttonTapped() {
        isSearching = true
    }
}

extension SearchView {
    
    override func configureAppearance() {
        configSearchBar()
        configCityLabel()
        configSearchButton()
    }
    
    override func addSubviews() {
        addSubview(searchButton)
        addSubview(locationLabel)
        addSubview(searchBar)
    }
    
    override func layoutConstraints() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.Offset.medium),
            searchButton.heightAnchor.constraint(equalTo:  heightAnchor, multiplier: 0.75),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.Offset.medium),
            
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.Offset.medium),
            searchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            searchBar.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 0) // Устанавливаем пропорциональную ширину
        ])
        
    }

}

extension SearchView : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.searchCity(city: text)
        stopEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stopEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.font = UIFont.systemFont(ofSize: 20)
                textField.textColor = Constants.tintColor
            }
        }
    
}
