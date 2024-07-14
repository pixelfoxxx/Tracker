//
//  SwitchCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

struct SwitchCellViewModel {
    let text: String?
    let isOn: Bool?
    let onChange: SwitchCell.SwitchClousure
}

final class SwitchCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let uiSwitch = UISwitch()
    private let stackView = UIStackView()
    
    static let reuseIdentifier = "SwitchCell"
    typealias SwitchClousure = (Bool) -> Void
    
    var viewModel: SwitchCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.text
            uiSwitch.isOn = viewModel?.isOn ?? false
            valueChanged = viewModel?.onChange
        }
    }
    
    private var valueChanged: SwitchClousure?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .cellBackground
        setupStackView()
        setupToggle()
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(uiSwitch)
    }
    
    private func setupToggle() {
        uiSwitch.onTintColor = .control
        uiSwitch.addTarget(self, action: #selector(onChange), for: .valueChanged)
    }
    
    @objc private func onChange() {
        guard let viewModel = viewModel else { return }
        viewModel.onChange(uiSwitch.isOn)
    }
}
