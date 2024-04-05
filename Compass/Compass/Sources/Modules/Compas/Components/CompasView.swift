//
//  CompasView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

//MARK: - Это финальная сборка компаса

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
    

}


final class CompasView : BaseView {
    
    //MARK: - UI Elements
        
    private let backgroundStaticView = BackGroundStaticView() // подложка под вращалку, типа указатель на север
    private let rotatingView = RoatatingDynamicView() // вью, реагируюее на изменение радианы
    
    private let topBlackStaticView = UIView() // поверх тех вью накидываем черный круг.
    // На topBlackStaticView накинем верт и горизонтальные полосы
    private let VLine = UIView()
    private let HLine = UIView()
    
    // directionLabelsView - прозрачный вью, по которому будут вращаться нащи буквы
    private let directionLabelsView = UIView()
    private var directionLabels : [UILabel] = []
    
    //MARK: - Overriding parent methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
        addDirectionLetters()
    }
    
    //MARK: - Public methods
    
    // Запускает анимацию вращения
    public func rotate(for angle: CGFloat) {
        self.rotatingView.rotate(for: angle)
        UIView.animate(withDuration: 0.1) {
            self.directionLabelsView.transform = CGAffineTransform(rotationAngle: -angle * .pi / 180)
            for direction in self.directionLabels {
                direction.transform = CGAffineTransform(rotationAngle: angle * .pi / 180)
            }
        }
    }
    
    //MARK: - Private methods
    
    private func setCornerRadius() {
        topBlackStaticView.layer.cornerRadius = frame.width/2*Constants.Sizes.blackCircleMultiplier
    }
    
    private func configViews() {
        topBlackStaticView.backgroundColor = Constants.Colors.blackColor
        rotatingView.backgroundColor = .clear
        backgroundStaticView.layer.zPosition = -1
        directionLabelsView.backgroundColor = .clear
    }
    
    private func configLines() {
        VLine.backgroundColor = Constants.Colors.whiteColor
        VLine.transform = CGAffineTransform(rotationAngle: 0)
        
        HLine.backgroundColor = Constants.Colors.whiteColor
        HLine.transform = CGAffineTransform(rotationAngle: .pi / 180)
    }
    
    private func addDirectionLetters() {
        let radius = topBlackStaticView.frame.width / 2 - 25 // задаем радиус по которому накидаем радианы. Отступ от ширины рамки 25 путем перебора
        let center = CGPoint(x: topBlackStaticView.frame.midX-20,
                             y: topBlackStaticView.frame.midY-20) // ценруем
        let fontSize : CGFloat =  18 // через fontSize задаем ширину вью
        
        // должно идти от 0 до 360, но тогда цифры в некорректном порядке добавляются
        // Делаю поздно вечером, голова не варит понять в какую сторону правильнее копать
        for radiana in stride(from: 270, to: 630, by: 90) {
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
        label.textColor = .white
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: angle)
        
        label.text = Direction(azimuth: Double(radiana-270))?.rawValue
        directionLabels.append(label)
            directionLabelsView.addSubview(label)
    }
}


extension CompasView {
    
    override func configureAppearance() {
        configViews()
        configLines()
    }
    
    override func addSubviews() {
        addSubview(backgroundStaticView)
        addSubview(rotatingView)
        addSubview(topBlackStaticView)
        
        topBlackStaticView.addSubview(directionLabelsView)
        topBlackStaticView.addSubview(VLine)
        topBlackStaticView.addSubview(HLine)
    }
    
    override func layoutConstraints() {
        backgroundStaticView.translatesAutoresizingMaskIntoConstraints = false
        rotatingView.translatesAutoresizingMaskIntoConstraints = false
        topBlackStaticView.translatesAutoresizingMaskIntoConstraints = false
        
        directionLabelsView.translatesAutoresizingMaskIntoConstraints = false
        VLine.translatesAutoresizingMaskIntoConstraints = false
        HLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            backgroundStaticView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            backgroundStaticView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            backgroundStaticView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundStaticView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rotatingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rotatingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rotatingView.topAnchor.constraint(equalTo: topAnchor),
            rotatingView.bottomAnchor.constraint(equalTo: bottomAnchor),

            topBlackStaticView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            topBlackStaticView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            topBlackStaticView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topBlackStaticView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            directionLabelsView.leadingAnchor.constraint(equalTo: topBlackStaticView.leadingAnchor),
            directionLabelsView.trailingAnchor.constraint(equalTo: topBlackStaticView.trailingAnchor),
            directionLabelsView.topAnchor.constraint(equalTo: topBlackStaticView.topAnchor),
            directionLabelsView.bottomAnchor.constraint(equalTo: topBlackStaticView.bottomAnchor),
            
            VLine.centerXAnchor.constraint(equalTo: topBlackStaticView.centerXAnchor),
            VLine.centerYAnchor.constraint(equalTo: topBlackStaticView.centerYAnchor),
            VLine.heightAnchor.constraint(equalTo: topBlackStaticView.widthAnchor, multiplier: 0.6),
            VLine.widthAnchor.constraint(equalToConstant: 0.5),
            
            HLine.centerXAnchor.constraint(equalTo: topBlackStaticView.centerXAnchor),
            HLine.centerYAnchor.constraint(equalTo: topBlackStaticView.centerYAnchor),
            HLine.heightAnchor.constraint(equalToConstant: 0.5),
            HLine.widthAnchor.constraint(equalTo: topBlackStaticView.widthAnchor, multiplier: 0.6)
        ])
    }
    
}
