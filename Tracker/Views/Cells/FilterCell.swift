//
//  FilterCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import UIKit

struct FilterCellViewModel {
    let title: String
    let filter: Filter
    var isSelected: Bool
    let selectFilter: (Filter) -> Void
}

final class FilterCell: UITableViewCell {
    static let reuseIdentifier = "FilterCell"
    
    private var titleLabel = UILabel()
    
    var viewModel: FilterCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            accessoryType = viewModel?.isSelected ?? false ? .checkmark : .none
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
        backgroundColor = .cellBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .insets),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        titleLabel.backgroundColor = .clear
        titleLabel.layer.cornerRadius = .cornerRadius
        titleLabel.clipsToBounds = true
        titleLabel.textColor = .navigationBarItem
    }
}

private extension CGFloat {
    static let cornerRadius = 16.0
    static let insets = 16.0
}
