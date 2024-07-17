//
//  BackgroundView.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 14/02/2024.
//

import UIKit

final class BackgroundView: UIView {
    
    private let imageView:  UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "background.error")
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(textLabel)
        
        setupImageViewConstraints()
        setupTextLabelConstraints()
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: .imageViewHeight),
            imageView.widthAnchor.constraint(equalToConstant: .imageViewWidth)
        ])
    }
    
    private func setupTextLabelConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .insets),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: .textLabelHeight)
        ])
    }
    
}

private extension CGFloat {
    static let imageViewWidth = 80.0
    static let imageViewHeight = 80.0
    static let textLabelHeight = 18.0
    static let insets = 8.0
}
