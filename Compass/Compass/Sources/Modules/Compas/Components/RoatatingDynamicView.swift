//
//  RoatatingDynamicView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

fileprivate enum Constants {
    
    enum Colors {
        static let whiteColor = UIColor.white
        static let blackColor = UIColor.black
    }
    
    enum Sizes {
        static let pointerWidth : CGFloat = 4
        static let blackCircleMultiplier : CGFloat = 0.85
        static let pointerMultiplier : CGFloat = 1.2
    }
    
    enum Image {
        static let arrowhead = UIImage(named: "arrowhead")
    }
}

//MARK: - Это фигура 2. Она должна вращаться. Белые полосы, надписи и все такое

final class RoatatingDynamicView: BaseView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGeometryLines(for: rect)
        if radianLabels.isEmpty {
            addNumbers()
        }
    }
    
    //MARK: - UI Elements
    
    private let northArrow = UIImageView()
    
    var radianLabels : [UILabel] = []

    //MARK: - Public methods
    
    public func rotate(for angle: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(rotationAngle: -angle * .pi / 180)
            self.reverseRotation(angle: angle)
        }
    }
    
    //MARK: - Private methods
    
    private func configNorthArrowImageView() {
        northArrow.image = Constants.Image.arrowhead
        northArrow.transform = CGAffineTransform(rotationAngle: .pi)
        northArrow.contentMode = .scaleAspectFit
    }
    
    // Метод вращающий радианы в обратном направлении, чтобы они всегда были горизонтальны
    private func reverseRotation(angle: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            for radian in self.radianLabels {
                radian.transform = CGAffineTransform(rotationAngle: angle * .pi/180)
            }
        }
    }
    
    // Метод накидывает цифры радиан по окружности
    private func addNumbers() {
        let radius = frame.width / 2 + 30 // задаем радиус по которому накидаем радианы. Отступ от ширины рамки 30 путем перебора
        let center = CGPoint(x: frame.midX, y: frame.midY) // ценруем
        let fontSize : CGFloat =  18 // через fontSize задаем ширину вью

        // должно идти от 0 до 360, но тогда цифры в некорректном порядке добавляются
        // Делаю поздно вечером, голова не варит понять в какую сторону правильнее копать
        for radiana in stride(from: 270, to: 630, by: 30) {
            let angle = CGFloat(radiana + 1) * .pi / 180 // Переводим градусы в радианы. Тут 'radiana' для баланса, без него смещение чуть не то
            let x = center.x + radius * cos(angle) - fontSize*1.8 / 2
            let y = center.y + radius * sin(angle) - fontSize / 2
            
            let frame = CGRect(x: x, y: y, width: fontSize * 1.8, height: fontSize)
            addLabel(radiana: radiana, frame: frame, fontSize: fontSize, angle: angle)
        }
    }
    
    // добавляем лейбл на экран в методе addNumbers()
    private func addLabel(radiana: Int, frame: CGRect, fontSize : CGFloat, angle: CGFloat) {
        let label = UILabel(frame: frame)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Constants.Colors.whiteColor
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: angle)
        
        label.text = "\(radiana-270)" // с просто "i" 0 стоит на месте 90
        radianLabels.append(label)
        addSubview(label)
    }

}

extension RoatatingDynamicView {

    override func configureAppearance() {
        super.configureAppearance()
        configNorthArrowImageView()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(northArrow)

    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        northArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            northArrow.bottomAnchor.constraint(equalTo: topAnchor, constant: -3),
            northArrow.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.5),
            northArrow.widthAnchor.constraint(equalToConstant: 20),
            northArrow.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
}


extension RoatatingDynamicView {
    
    private func drawGeometryLines(for rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        
        let numberOfSlices = 180
        let sliceAngle = CGFloat(2 * Double.pi) / CGFloat(numberOfSlices)
        
        for i in 0..<numberOfSlices {
            let startAngle = CGFloat(i) * sliceAngle
            var endAngle : CGFloat = 0
            if i % 15 == 0 || i == 0 {
                endAngle = CGFloat(Double(i) + 0.7) * sliceAngle
            } else {
                endAngle = CGFloat(Double(i) + 0.3) * sliceAngle
            }
            
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            context.setFillColor(UIColor.white.cgColor)
            context.fillPath()
        }
    }
}
