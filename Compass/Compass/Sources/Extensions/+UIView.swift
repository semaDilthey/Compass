//
//  +UIView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 07.04.2024.
//

import UIKit

extension UIView {
    
    func animateTouch(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [.touchDown, .touchDragInside])
        
        button.addTarget(self, action: #selector(handleOut), for: [.touchCancel, .touchDragOutside, .touchUpOutside, .touchUpInside, .touchDragExit])
        
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0.55
        }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func dropShadow(on view: UIView, shadowColor: UIColor, drop: Bool) {
        if drop {
            view.layer.shadowOpacity = 0.3
        } else {
            view.layer.shadowOpacity = 0
        }
        view.layer.cornerRadius = view.layer.cornerRadius
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
    }
}
