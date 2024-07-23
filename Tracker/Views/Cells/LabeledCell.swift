//
//  LabeledCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 21.02.2024.
//  
//

import UIKit

struct LabeledCellViewModel {
    enum Style {
        case button
        case leftSideTitle
    }
    let title: String
    let style: Style
}
final class LabeledCell: UITableViewCell {
    
    static let reuseIdentifier = "LabeledCell"
    
    private var titleLabel = UILabel()
    
    var viewModel: LabeledCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            titleLabel.textAlignment = viewModel?.style == .button ? .center : .left
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = viewModel?.style == .button ? .buttons : .cellBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewModel?.style == .button
            ? titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            : titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .insets),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        titleLabel.backgroundColor = .clear
        titleLabel.layer.cornerRadius = .cornerRadius
        titleLabel.clipsToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = viewModel?.style == .button ? .background : .navigationBarItem
    }
}

private extension CGFloat {
    static let cornerRadius = 16.0
    static let insets = 16.0
}
