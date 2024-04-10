//
//  BaseNavController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 06.04.2024.
//

import UIKit

class BaseNavController : UINavigationController {
    
    private let titleFontSize : CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Configure nav bar appearance
    private func configure() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .accent
        navBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: titleFontSize)]
        navBarAppearance.shadowColor = .accent
        navigationBar.tintColor = .white

        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.isTranslucent = false
    }
    
}
