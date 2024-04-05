//
//  BaseView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

@objc protocol IBaseView : AnyObject {
    func configureAppearance()
    func addSubviews()
    func layoutConstraints()
}

public class BaseView : UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BaseView : IBaseView {
    
    func configureAppearance() {}
    
    func addSubviews() {}
    
    func layoutConstraints() {}
    
}
