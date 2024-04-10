//
//  SettingsViewController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 10.04.2024.
//

import UIKit
import Combine

private extension String {
    static let navBarTitle = "Settings"
}

private extension CGFloat {
    static let tableCellHeight : CGFloat = 70
}

/// Для каждой строки нашей таблицы можно добавлять отдельный метод
protocol SettingsDelegate : AnyObject {
    func changeColorScheme(toLight: Bool)
}

final class SettingsViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel : ISettingsViewModel
    private var cancellables : Set<AnyCancellable> = []
    weak var delegate : SettingsDelegate?
    
    //MARK: - Init
    
    init(viewModel: ISettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
    
    private lazy var tableView = UITableView()
    
    //MARK: - Private methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
    }
    
}

extension SettingsViewController {
    
    override func configureComponents() {
        configureTableView()
        viewModel.setSettingsData()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        addNavBarItem(at: .center, title: .navBarTitle)
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
        if let tableModel = viewModel.getTableModel(at: indexPath) {
            let cellView = SettingsCellContentView()
            cell.set(view: cellView, model: tableModel)
        }
        viewModel.sendChangesToRoot(sender: self, from: cell, at: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .tableCellHeight
    }
}
