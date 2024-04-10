//
//  SettingsCell.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import UIKit
import Combine

final class SettingsCell : UITableViewCell {
    
    //MARK: - Properties
    
    static var identifier : String { "\(Self.self)" }
    
    var isSwitcherOn = CurrentValueSubject<Bool, Never>(false)
    var cancellables : Set<AnyCancellable> = []
    
    //MARK: -  Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        settingsCellContentView?.prepareForReuse()
    }
    
    //MARK: - UI
    
    private var containerView = UIView()
    private var settingsCellContentView : SettingsCellContentView?
    
    //MARK: - Public methods
    
    public func set(view: SettingsCellContentView?, model: ISettingsTableCellModel) {
        settingsCellContentView = view
        settingsCellContentView?.configure(with: model)
        
        addSettingsSubview(settingsCellContentView: settingsCellContentView)
        bind(view: view)
    }
    
    private func bind(view: SettingsCellContentView?) {
        settingsCellContentView?.isSwitcherOn
            .sink(receiveValue: { [weak self] isOn in
            self?.isSwitcherOn.send(isOn)
        })
            .store(in: &cancellables)
    }
    
    //MARK: - Private methods
    
    private func addSettingsSubview(settingsCellContentView: SettingsCellContentView?) {
        guard let settingsCellContentView else { return }
        
        containerView.addSubview(settingsCellContentView)
        settingsCellContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsCellContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingsCellContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            settingsCellContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            settingsCellContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

extension SettingsCell {
    
    private func configureAppearance() {
        backgroundColor = .clear
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    private func layoutConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.Offset.medium/2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -C.Offset.medium/2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.Offset.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -C.Offset.medium/2)
        ])
    }
    
}
