//
//  StatisticElementView.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import UIKit

struct StatisticElementViewModel {
    let title: String
    let count: Int
    
    static let empty = StatisticElementViewModel(title: "", count: 0)
}

final class StatisticElementView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    var model: StatisticElementViewModel = .empty {
        didSet {
            setupView()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    private let shape = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(countLabel)
        addSubview(titleLabel)
        setupCountLabel()
        setupTitleLabel()
        configureGradientLayer()
    }
    
    private func setupView() {
        countLabel.text = String(model.count)
        titleLabel.text = model.title
    }
    
    private func setupCountLabel() {
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: .insets),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .insets),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.insets),
            countLabel.heightAnchor.constraint(equalToConstant: .countLabelHeight)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: .topInset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .insets),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.insets),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.insets),
            titleLabel.heightAnchor.constraint(equalToConstant: .titleLabelHeight)
        ])
    }
    
    private func configureGradientLayer() {
        let gradientColors: [CGColor] = [
            UIColor(hex: "#007BFA")?.cgColor ?? UIColor.blue.cgColor,
            UIColor(hex: "#46E69D")?.cgColor ?? UIColor.green.cgColor,
            UIColor(hex: "#FD4C49")?.cgColor ?? UIColor.red.cgColor
        ]
        
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        shape.lineWidth = 1
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = nil
        
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = shape
        layer.cornerRadius = .cornerRadius
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: .cornerRadius).cgPath
    }
}

fileprivate extension CGFloat {
    static let insets: CGFloat = 12
    static let cornerRadius: CGFloat = 16
    static let countLabelHeight: CGFloat = 40
    static let titleLabelHeight: CGFloat = 20
    static let topInset: CGFloat = 7
}
