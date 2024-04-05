//
//  BaseViewController.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

@objc protocol IBaseViewController : AnyObject {
    func configureAppearance()
    func configureComponents()
    func addSubviews()
    func layoutConstraints()
    
    func bind()
}

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
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension BaseViewController : IBaseViewController {
    func configureAppearance() {
        view.backgroundColor = .black
    }
    
    func configureComponents() {}
    
    func addSubviews() {}
    
    func layoutConstraints() {}
    
    func bind() {}
}
