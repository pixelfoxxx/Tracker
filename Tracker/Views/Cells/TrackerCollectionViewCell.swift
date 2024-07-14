//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 18/02/2024.
//

import UIKit

struct TrackerCollectionViewCellViewModel {
    var emoji: String?
    var title: String?
    var isPinned: Bool?
    var daysCount: Int?
    var color: UIColor?
    var doneButtonHandler: TrackerCollectionViewCell.ActionClousure
    var isCompleted: Bool
    
    init(
        emoji: String?,
        title: String?,
        isPinned: Bool?,
        daysCount: Int?,
        color: UIColor?,
        doneButtonHandler: @escaping TrackerCollectionViewCell.ActionClousure,
        isCompleted: Bool
    ) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
        self.color = color
        self.doneButtonHandler = doneButtonHandler
        self.isCompleted = isCompleted
    }
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    typealias ActionClousure = () -> Void
    
    static let reuseIdentifier = "TrackerCollectionViewCell"
    
    private let coloredRectangleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    private let whiteEmojiBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    private let nonColoredRectangleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var doneAction: ActionClousure = {}
    
    var viewModel: TrackerCollectionViewCellViewModel? {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coloredRectangleView.layer.cornerRadius = 16
        coloredRectangleView.layer.masksToBounds = true
        
        whiteEmojiBackground.layer.cornerRadius = 12
        whiteEmojiBackground.clipsToBounds = true
        
        doneButton.layer.cornerRadius = 17
        doneButton.clipsToBounds = true
    }
    
    private func setupUI() {
        contentView.addSubview(coloredRectangleView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(whiteEmojiBackground)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nonColoredRectangleView)
        contentView.addSubview(daysCountLabel)
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            coloredRectangleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coloredRectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coloredRectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coloredRectangleView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.centerXAnchor.constraint(equalTo: whiteEmojiBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: whiteEmojiBackground.centerYAnchor),
            
            whiteEmojiBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            whiteEmojiBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            whiteEmojiBackground.widthAnchor.constraint(equalToConstant: 24),
            whiteEmojiBackground.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: coloredRectangleView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: coloredRectangleView.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            titleLabel.bottomAnchor.constraint(equalTo: coloredRectangleView.bottomAnchor, constant: -12),
            
            nonColoredRectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nonColoredRectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nonColoredRectangleView.topAnchor.constraint(equalTo: coloredRectangleView.bottomAnchor),
            nonColoredRectangleView.heightAnchor.constraint(equalToConstant: 58),
            
            doneButton.trailingAnchor.constraint(equalTo: nonColoredRectangleView.trailingAnchor, constant: -12),
            doneButton.bottomAnchor.constraint(equalTo: nonColoredRectangleView.bottomAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            
            daysCountLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: nonColoredRectangleView.leadingAnchor, constant: 12)
        ])
    }
    
    private func setup() {
        setupTitleLabel()
        setupDaysCountLabel()
        setupContainerView()
        setupDoneButton()
        setupEmojiLabel()
    }
    
    private func setupContainerView() {
        guard let viewModel else { return }
        coloredRectangleView.backgroundColor = viewModel.color
    }
    
    private func setupDaysCountLabel() {
        guard let viewModel else { return }
        daysCountLabel.text = "\(viewModel.daysCount ?? 0) \(pluralizeDays(viewModel.daysCount ?? 0))"
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "день"
        } else if remainder10 >= 2 && remainder100 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "дня"
        } else {
            return "дней"
        }
    }
    
    private func setupTitleLabel() {
        guard let viewModel else { return }
        titleLabel.text = viewModel.title
    }
    
    private func setupEmojiLabel() {
        guard let viewModel else { return }
        emojiLabel.text = viewModel.emoji
    }
    
    private func setupDoneButton() {
        guard let viewModel else { return }
        let buttonImage = viewModel.isCompleted ? Assets.Images.done : Assets.Images.plus
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneButton.setImage(buttonImage, for: .normal)
        doneButton.backgroundColor = viewModel.color
        doneButton.alpha = viewModel.isCompleted ? 0.3 : 1
        doneAction = viewModel.doneButtonHandler
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    @objc private func doneButtonAction() {
        doneAction()
    }
}
