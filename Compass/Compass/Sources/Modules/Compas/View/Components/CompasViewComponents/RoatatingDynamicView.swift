//
//  RoatatingDynamicView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit
import CoreGraphics

fileprivate enum Constants {
    
    enum Sizes {
        static let pointerWidth : CGFloat = 4
        static let blackCircleMultiplier : CGFloat = 0.85
        static let pointerMultiplier : CGFloat = 1.2
    }
    
    enum Image {
        static let arrowhead = UIImage(named: "arrowhead")
    }
}

//MARK: - Фигура 2. Вращающийся диск, отрисовка в методе draw, сохранение формы в свойство linesContext, отрисовка радиан, сохранение в массив radianLabels

final class RoatatingDynamicView: BaseView {
    
    //MARK: - Properties
    
    var appearance : CompasAppearance = CompasAppearance()
        
    //MARK: - Init
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGeometryLines(for: rect)
        
        if radianLabels.isEmpty { // без этой проверки при каждом переходи из background в foreground заново отрисовывает элементы поверх существующих
            addNumbers()
        }
    }

        
    //MARK: - UI Elements
    
    private let northArrow = UIImageView()
    private var radianLabels : [UILabel] = []
    private var linesContext : CGContext?
    
    //MARK: - Public methods
    
    public func configure(with appearance: CompasAppearance) {
        self.appearance = appearance
        if !radianLabels.isEmpty {
            for label in radianLabels {
                label.textColor = appearance.colorScheme.color
            }
        }
            linesContext?.setFillColor(appearance.colorScheme.color.cgColor)
            setNeedsDisplay()
    }
    
    /// Функция настройки вращения диска извне
    /// - Parameter angle: угол поворота компаса
    public func rotate(for angle: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(rotationAngle: -angle.inRadians)
            self.reverseRotation(angle: angle)
        }
    }
    
    //MARK: - Private methods
    
    private func configNorthArrowImageView() {
        northArrow.image = Constants.Image.arrowhead
        northArrow.transform = CGAffineTransform(rotationAngle: .pi)
        northArrow.contentMode = .scaleAspectFit
    }
    
    /// Метод вращающий радианы в обратном направлении, чтобы они всегда были горизонтальны
    private func reverseRotation(angle: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            for radian in self.radianLabels {
                radian.transform = CGAffineTransform(rotationAngle: angle.inRadians)
            }
        }
    }
    
    /// Метод накидывает цифры радиан по окружности
    private func addNumbers() {
        let radius = frame.width / 2 + 30 // задаем радиус по которому накидаем радианы. Отступ от ширины рамки 30 путем перебора
        let center = CGPoint(x: frame.midX, y: frame.midY) // ценруем
        let fontSize : CGFloat =  18 // через fontSize задаем ширину вью

        // должно идти от 0 до 360, но тогда цифры в некорректном порядке добавляются
        // Делаю поздно вечером, голова не варит понять в какую сторону правильнее копать
        let angleBetweenNumbers = 30
        for radiana in stride(from: 270, to: 630, by: angleBetweenNumbers) {
            let angle = CGFloat(radiana + 1) * .pi / 180 // Переводим градусы в радианы. Тут 'radiana' для баланса, без него смещение чуть не то
            let x = center.x + radius * cos(angle) - fontSize*1.8 / 2
            let y = center.y + radius * sin(angle) - fontSize / 2
            
            let frame = CGRect(x: x, y: y, width: fontSize * 1.8, height: fontSize)
            addLabel(radiana: radiana, frame: frame, fontSize: fontSize, angle: angle)
        }
    }
    
    /// добавляем лейбл на экран в методе addNumbers()
    private func addLabel(radiana: Int, frame: CGRect, fontSize : CGFloat, angle: CGFloat) {
        let label = UILabel(frame: frame, fontSize: fontSize, angle: angle)
        label.text = "\(radiana-270)" // с просто "i" 0 стоит на месте 90
        /* ------------------------------------------------ */
        label.textColor = appearance.colorScheme.color          // Ставим цвет в зависимости от выбранной цветовой схемы
        /* ------------------------------------------------ */
        radianLabels.append(label)
        addSubview(label)
    }

}

//MARK: - Overriding parent methods

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


//MARK: - Creating geometry lines
extension RoatatingDynamicView {
    
    private func drawGeometryLines(for rect: CGRect) {
        
        linesContext = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        
        let linesQuantity = 180
        let sliceAngle = CGFloat(2 * Double.pi) / CGFloat(linesQuantity)
        let angleBetweenLines = 15
        
        for i in 0..<linesQuantity {
            let startAngle = CGFloat(i) * sliceAngle
            var endAngle : CGFloat = 0
            if i % angleBetweenLines == 0 || i == 0 {
                endAngle = CGFloat(Double(i) + 0.7) * sliceAngle
            } else {
                endAngle = CGFloat(Double(i) + 0.3) * sliceAngle
            }
            
            linesContext?.move(to: center)
            linesContext?.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            /* ------------------------------------------------ */
            linesContext?.setFillColor(appearance.colorScheme.color.cgColor)     // Ставим цвет в зависимости от выбранной цветовой схемы
            /* ------------------------------------------------ */
            linesContext?.fillPath()
        }
    }
}
