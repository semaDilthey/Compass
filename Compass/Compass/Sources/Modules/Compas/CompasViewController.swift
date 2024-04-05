//
//  CompasViewController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit
import Combine

final class CompasViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel : ICompasViewModel
    var cancelables: Set<AnyCancellable> = []
    
    //MARK: - Init
    
    init(viewModel: ICompasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    let location = UILabel()
    let direction = UILabel()
    let radians = UILabel()
    
    let compasView = CompasView()
    
    //MARK: - Private methods
    
    private func configLabels() {
        location.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        radians.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        direction.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    

}

extension CompasViewController {
    
    override func configureAppearance() {
        super.configureAppearance()
        configLabels()
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(location)
        view.addSubview(direction)
        view.addSubview(radians)
        view.addSubview(compasView)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        location.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [radians, direction])
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = C.Offset.medium
        
        compasView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            location.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            location.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: C.Offset.medium),
            
            compasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compasView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            compasView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            compasView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: compasView.bottomAnchor, constant: C.Offset.medium*8)
        ])
    }
    
    override func bind() {
        super.bind()

        viewModel.location.sink { location in
            self.location.text = location
        }.store(in: &cancelables)
        
        viewModel.direction.sink { direction in
            self.direction.text = direction
        }.store(in: &cancelables)
        
        viewModel.heading.sink { heading in
            self.radians.text = String(heading) + " " + C.Strings.radians
            UIView.animate(withDuration: 0.1) {
                self.compasView.rotate(for: CGFloat(heading))
            }
        }.store(in: &cancelables)
    }
}
