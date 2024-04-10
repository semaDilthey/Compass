//
//  BaseViewController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

@objc private protocol IBaseViewController : AnyObject {
    func configureAppearance()
    func configureComponents()
    func addSubviews()
    func layoutConstraints()
    
    func bind()
    
    func navBarLeftItemHandler()
    func navBarRightItemHandler()
}

/// Базовый класс для приложения. Позволяет более гибко подходить с проектированию приложения и ускорит расширение приложения
/// За счет разбиения всех методов будущих сабклассов по методам суперкласса можно добиться более единого стиля и удобства читаемости
public class BaseViewController : UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureComponents()
        addSubviews()
        layoutConstraints()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setButtonsSizes()
    }
    
    //MARK: - UI for configuring NavBar right/center/left elements
    
    private let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    private lazy var leftBarButton : UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.addTarget(self, action: #selector(navBarLeftItemHandler), for: .touchUpInside)
        leftBarButton.animateTouch(leftBarButton)
        return leftBarButton
    }()
    
    private lazy var rightBarButton : UIButton = {
        let rightBarButton = UIButton()
        rightBarButton.addTarget(self, action: #selector(navBarRightItemHandler), for: .touchUpInside)
        rightBarButton.animateTouch(rightBarButton)
        return rightBarButton
    }()
    
    private func setButtonsSizes() {
        rightBarButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        rightBarButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        leftBarButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftBarButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    //MARK: - Some methods
    
    public func hideNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    public func showNavBar() {
        navigationController?.isNavigationBarHidden = false
    }
    
    public func setNavBarTintColor(color: UIColor) {
        titleLabel.textColor = color
        navigationController?.navigationBar.tintColor = color
    }
}

//MARK: - Дефолтная реализация

extension BaseViewController : IBaseViewController {
    func configureAppearance() {
        view.backgroundColor = .black
    }
    func configureComponents() {}
    func addSubviews() {}
    func layoutConstraints() {}
    func bind() {}
    
    func navBarLeftItemHandler() {
        print("Left selector was tapped")
    }
    
    func navBarRightItemHandler() {
        print("Right selector was tapped")
    }
       
}


enum NavBarPosition {
    case left(type: NavBarItemType)
    case right(type: NavBarItemType)
    case center
}

enum NavBarItemType {
    case button(image: UIImage? = nil)
    case label
}

//MARK: - Метод для гибкой и быстрой настройки навБара. Опять же, меняется как угодно в зависимости от требований

extension BaseViewController {
    
    /// Вызови метод в контроллере и добавляй элементы в нав бар
    /// - Parameters:
    ///   - position: лево/право - кнопки, лейблы. центр - лейбл
    ///   - title: Установка текста в титл лейбла или кнопки
    func addNavBarItem(at position: NavBarPosition, title : String? = nil) {
        switch position {
            
        case let .left(type):
            switch type {
            case let .button(image):
                leftBarButton.setImage(image, for: .normal)
                leftBarButton.setTitle(title, for: .normal)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
            case .label:
                self.titleLabel.text = title
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
            }
            
        case let .right(type):
            switch type {
            case let .button(image):
                rightBarButton.setImage(image, for: .normal)
                rightBarButton.setTitle(title, for: .normal)
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
            case .label:
                self.titleLabel.text = title
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleLabel)
            }
        
        case .center:
            self.titleLabel.text = title
            navigationItem.titleView = titleLabel
        }
    }
}
