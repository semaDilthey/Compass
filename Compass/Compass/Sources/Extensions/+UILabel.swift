//
//  +UILabel.swift
//  Compass
//
//  Created by Семен Гайдамакин on 06.04.2024.
//

import UIKit

extension UILabel {
    
    /// Создает UILabel конктрено под мои нужды в этом проекте, дабы не дублироваться вынес сюда
    /// - Parameters:
    ///   - frame: frame
    ///   - fontSize: размер шрифта лейбла
    ///   - angle: угол под который лейбл поверенется при поставке на вью
    convenience init(frame: CGRect, fontSize: CGFloat, angle: CGFloat) {
        self.init(frame: frame)
        font = UIFont.systemFont(ofSize: fontSize)
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        transform = CGAffineTransform(rotationAngle: angle)
    }
}
