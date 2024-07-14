//
//  LabledCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 21.02.2024.
//  
//

import UIKit

struct LabledCellViewModel {
    let title: String
}
final class LabledCell: UITableViewCell {
    
    static let reuseIdentifier = "LabledCell"
    
    private var titleLabel = UILabel()
    
    var viewModel: LabledCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        titleLabel.backgroundColor = .buttons
        titleLabel.layer.cornerRadius = 16
        titleLabel.clipsToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .background
    }
}
