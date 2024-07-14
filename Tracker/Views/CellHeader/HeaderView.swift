//
//  HeaderView.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 17/03/2024.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "HeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .insets),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private extension CGFloat {
    static let insets = 16.0
}

