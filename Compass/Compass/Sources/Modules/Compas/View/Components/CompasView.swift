//
//  CompasView.swift
//  Compass
//
//  Created by Семен Гайдамакин on 04.04.2024.
//

import UIKit

fileprivate enum Constants {
    
    enum Colors {
        static let whiteColor = UIColor.white
    }
    
    enum Sizes {
        static let pointerWidth : CGFloat = 4
        static let blackCircleMultiplier : CGFloat = 0.85
        static let pointerMultiplier : CGFloat = 1.2
    }
}

//MARK: - Это финальная сборка компаса

final class CompasView : BaseView {
    
    //MARK: - Properties
    
    private var appearance : CompasAppearance
    
    //MARK: - Init
    
    init(appearance: CompasAppearance = CompasAppearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
    /// Белый вертикальный указатель на север
    private let whitePointer = UIView()
    
    /// вью, реагируюее на изменение радианы
    private let rotatingView = RoatatingDynamicView()
    
    /// поверх rotatingView накидываем статичный круг для вида.
    private let topBlackStaticView = UIView()
    
    /// На topBlackStaticView накинем верт и горизонтальные полосы
    private let VLine = UIView()
    private let HLine = UIView()
    
    /// прозрачный вью, по которому будут вращаться нащи буквы
    private let directionLabelsView = UIView()
    
    /// Заполняется в методе addDirectionLetters(), буквы сторон на компасе
    private var directionLabels : [UILabel] = []

    
    //MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
        addDirectionLetters()
    }
    
    //MARK: - Public methods
    /// инит внешности компаса
    public func setupView(with appearance: CompasAppearance) {
        self.appearance = appearance
        configureSubviews(with: appearance)
        rotatingView.configure(with: appearance)
    }
    
    /// Запускает анимацию вращения
    public func rotate(for angle: CGFloat) {
        self.rotatingView.rotate(for: angle)
        UIView.animate(withDuration: 0.1) {
            self.directionLabelsView.transform = CGAffineTransform(rotationAngle: -angle.inRadians )
            // Бувы N S E W всегда в горизонтали
            self.directionLabels.forEach { $0.transform = CGAffineTransform(rotationAngle: angle.inRadians ) }
        }
    }
    
    //MARK: - Private methods
    
    //MARK:  Configuring subviews from outside
    private func configureSubviews(with appearance: CompasAppearance) {
        topBlackStaticView.backgroundColor = appearance.diskColor.color
        directionLabels.forEach { $0.textColor = appearance.colorScheme.color }
    }
    
    //MARK: setting up subviews from inside
    private func setCornerRadius() {
        topBlackStaticView.layer.cornerRadius = frame.width/2 * Constants.Sizes.blackCircleMultiplier
    }
    
    private func configViews() {
        rotatingView.backgroundColor = .clear
        directionLabelsView.backgroundColor = .clear
    }
    
    private func configWhitePointer() {
        whitePointer.backgroundColor = Constants.Colors.whiteColor
        whitePointer.layer.zPosition = -1
    }
    
    
    private func configLines() {
        VLine.backgroundColor = Constants.Colors.whiteColor
        VLine.transform = CGAffineTransform(rotationAngle: 0)
        
        HLine.backgroundColor = Constants.Colors.whiteColor
        HLine.transform = CGAffineTransform(rotationAngle: .pi / 180)
    }
    
    // Добавляем N S E W  на directionLabelsView
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
        let label = UILabel(frame: frame, fontSize: fontSize, angle: angle)
        label.textColor = appearance.colorScheme.color
        
        label.text = Direction(azimuth: Double(radiana-270))?.rawValue
        directionLabels.append(label)
        directionLabelsView.addSubview(label)
    }
}


//MARK: - Overriding parent methods

extension CompasView {
    
    override func configureAppearance() {
        super.configureAppearance()
        configViews()
        configLines()
        configWhitePointer()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(whitePointer)

        addSubview(rotatingView)
        addSubview(topBlackStaticView)
        
        topBlackStaticView.addSubview(directionLabelsView)
        topBlackStaticView.addSubview(VLine)
        topBlackStaticView.addSubview(HLine)
    }
    
    override func layoutConstraints() {
        super.layoutConstraints()
        whitePointer.translatesAutoresizingMaskIntoConstraints = false

        rotatingView.translatesAutoresizingMaskIntoConstraints = false
        topBlackStaticView.translatesAutoresizingMaskIntoConstraints = false
        
        directionLabelsView.translatesAutoresizingMaskIntoConstraints = false
        VLine.translatesAutoresizingMaskIntoConstraints = false
        HLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            rotatingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rotatingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rotatingView.topAnchor.constraint(equalTo: topAnchor),
            rotatingView.bottomAnchor.constraint(equalTo: bottomAnchor),

            topBlackStaticView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            topBlackStaticView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Sizes.blackCircleMultiplier),
            topBlackStaticView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topBlackStaticView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            whitePointer.bottomAnchor.constraint(equalTo: topBlackStaticView.bottomAnchor),
            whitePointer.widthAnchor.constraint(equalToConstant: Constants.Sizes.pointerWidth),
            whitePointer.centerXAnchor.constraint(equalTo: topBlackStaticView.centerXAnchor),
            whitePointer.heightAnchor.constraint(equalTo: topBlackStaticView.heightAnchor, multiplier: Constants.Sizes.pointerMultiplier),
            
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
