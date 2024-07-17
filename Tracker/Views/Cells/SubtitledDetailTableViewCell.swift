//
//  SubtitledDetailTableViewCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 19.02.2024.
//  
//

import UIKit

struct SubtitledDetailTableViewCellViewModel {
    let title: String
    let subtitle: String?
    
    var action: () -> Void?
    
    static let empty: SubtitledDetailTableViewCellViewModel = .init(title: "", subtitle: "", action: {})
}

final class SubtitledDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SubtitledDetailTableViewCell"
    
    let titleLabel = UILabel()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subtitleText
        return label
    }()
    let stackView = UIStackView()
    
    private var onTapAction: (() -> Void?)? = nil
    
    var viewModel: SubtitledDetailTableViewCellViewModel = .empty {
        didSet {
            setup()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.awakeFromNib()
        configureView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        accessoryType = .disclosureIndicator
        backgroundColor = .cellBackground
        if viewModel.subtitle == nil || viewModel.subtitle == "" {
            subtitleLabel.removeFromSuperview()
        } else if subtitleLabel.superview == nil {
            stackView.addArrangedSubview(subtitleLabel)
        }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        onTapAction = viewModel.action
    }
    
    private func configureView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .stackViewLeadingInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .stackViewTrailingInset)
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .stackSpacing
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: .labelHeight)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.heightAnchor.constraint(equalToConstant: .labelHeight)
        ])
    }
}

private extension CGFloat {
    static let labelHeight = 22.0
    static let stackSpacing = 2.0
    static let stackViewTopInset = 15.0
    static let stackViewLeadingInset = 16.0
    static let stackViewBottomInset = 15.0
    static let stackViewTrailingInset = -56.0
}
