//
//  SettingsCellContentView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import UIKit
import Combine

private extension CGFloat {
    static let heightMultiplier : CGFloat = 0.45
}

final class SettingsCellContentView : BaseView {

    var isSwitcherOn = CurrentValueSubject<Bool, Never>(false)

    //MARK: - UI Elements
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let switcher = UISwitch()
    
    //MARK: - Public methods
    
    public func configure(with model: ISettingsTableCellModel) {
        iconView.image = model.icon
        titleLabel.text = model.title
    }
    
    public func prepareForReuse() {
        iconView.image = nil
        titleLabel.text = ""
        switcher.isOn = false
    }
    
    //MARK: - private methods
    
    private func configTitle() {
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configSwitcher() {
        switcher.addTarget(self, action: #selector(toggleSwitcher), for: .valueChanged)
    }
    
    @objc private func toggleSwitcher() {
        switcher.isOn ? (isSwitcherOn.send(true)) : (isSwitcherOn.send(false))
    }
}


extension SettingsCellContentView {
    
    override func configureAppearance() {
        super.configureAppearance()
        configTitle()
        configSwitcher()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(switcher)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        switcher.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.Offset.medium/2),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: .heightMultiplier),
            iconView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: .heightMultiplier),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: C.Offset.medium),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -C.Offset.medium),
            
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.Offset.medium),
            switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
