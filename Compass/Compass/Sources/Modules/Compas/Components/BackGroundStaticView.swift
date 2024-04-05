//
//  BackGroundStaticView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

//MARK: - Это фигура 1
// Она неподвижна
fileprivate enum Constants {
    
    enum Colors {
        static let whiteColor = UIColor.white
        static let blackColor = UIColor.black
    }
    
    enum Sizes {
        static let pointerWidth : CGFloat = 4
        static let blackCircleMultiplier : CGFloat = 1
        static let pointerMultiplier : CGFloat = 1.2
    }
}

final class BackGroundStaticView : BaseView {
    
    private let whitePointer = UIView()
    private let blackCircle = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blackCircle.layer.cornerRadius = frame.width/2
    }
    
    private func configWhitePointer() {
        whitePointer.backgroundColor = Constants.Colors.whiteColor
        whitePointer.layer.zPosition = -1
    }
    
    private func configBlackCircle() {
        blackCircle.backgroundColor = Constants.Colors.blackColor
    }
}

extension BackGroundStaticView {
    
    override func configureAppearance() {
        super.configureAppearance()
        configWhitePointer()
        configBlackCircle()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(whitePointer)
        addSubview(blackCircle)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        
        whitePointer.translatesAutoresizingMaskIntoConstraints = false
        blackCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blackCircle.bottomAnchor.constraint(equalTo: bottomAnchor),
            blackCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            blackCircle.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            blackCircle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            
            whitePointer.bottomAnchor.constraint(equalTo: blackCircle.bottomAnchor),
            whitePointer.widthAnchor.constraint(equalToConstant: Constants.Sizes.pointerWidth),
            whitePointer.centerXAnchor.constraint(equalTo: blackCircle.centerXAnchor),
            whitePointer.heightAnchor.constraint(equalTo: blackCircle.heightAnchor, multiplier: Constants.Sizes.pointerMultiplier)
        ])
    }
}


