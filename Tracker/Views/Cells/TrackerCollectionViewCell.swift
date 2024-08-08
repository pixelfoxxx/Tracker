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
    var isPinned: Bool
    var daysCount: Int?
    var color: UIColor?
    var doneButtonHandler: TrackerCollectionViewCell.ActionClousure
    var pinHandler: (Bool) -> Void
    var isCompleted: Bool
    var deleteTrackerHandler: () -> Void
    var editTrackerHandler: () -> Void
    
    init(
        emoji: String?,
        title: String?,
        isPinned: Bool,
        daysCount: Int?,
        color: UIColor?,
        doneButtonHandler: @escaping TrackerCollectionViewCell.ActionClousure,
        pinHandler: @escaping (Bool) -> Void,
        isCompleted: Bool,
        deleteTrackerHandler: @escaping () -> Void,
        editTrackerHandler: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.title = title
        self.isPinned = isPinned
        self.daysCount = daysCount
        self.color = color
        self.doneButtonHandler = doneButtonHandler
        self.pinHandler = pinHandler
        self.isCompleted = isCompleted
        self.deleteTrackerHandler = deleteTrackerHandler
        self.editTrackerHandler = editTrackerHandler
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
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    private var togglePinAction: ((Bool) -> Void)?
    private var deleteTrackerHandler: (() -> Void)?
    private var editTrackerHandler: (() -> Void)?
    
    var viewModel: TrackerCollectionViewCellViewModel? {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupContextMenu()
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
        contentView.addSubview(nonColoredRectangleView)
        coloredRectangleView.addSubview(emojiLabel)
        coloredRectangleView.addSubview(whiteEmojiBackground)
        coloredRectangleView.addSubview(titleLabel)
        coloredRectangleView.addSubview(pinImageView)
        nonColoredRectangleView.addSubview(daysCountLabel)
        nonColoredRectangleView.addSubview(doneButton)
        
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
            daysCountLabel.leadingAnchor.constraint(equalTo: nonColoredRectangleView.leadingAnchor, constant: 12),
            
            pinImageView.topAnchor.constraint(equalTo: coloredRectangleView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: coloredRectangleView.trailingAnchor, constant: -4),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setup() {
        setupTitleLabel()
        setupDaysCountLabel()
        setupContainerView()
        setupDoneButton()
        setupEmojiLabel()
        setupPinImageView()
        deleteTrackerHandler = viewModel?.deleteTrackerHandler
        editTrackerHandler = viewModel?.editTrackerHandler
    }
    
    private func setupContainerView() {
        guard let viewModel else { return }
        coloredRectangleView.backgroundColor = viewModel.color
    }
    
    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        coloredRectangleView.addInteraction(interaction)
    }
    
    private func setupDaysCountLabel() {
        guard let viewModel else { return }
        let daysCount = viewModel.daysCount ?? 0
        let daysWord = correctDaysForm(daysCount: daysCount)
        daysCountLabel.text = "\(daysCount) \(daysWord)"
    }
    
    private func setupTitleLabel() {
        guard let viewModel else { return }
        titleLabel.text = viewModel.title
    }
    
    private func setupPinImageView() {
        guard let viewModel else { return }
        pinImageView.isHidden = !(viewModel.isPinned)
        pinImageView.image = viewModel.isPinned
        ? UIImage(named: "PinImage")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        : nil
        togglePinAction = viewModel.pinHandler
       
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

//MARK: - UIContextMenuInteractionDelegate

extension TrackerCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [ weak self ] suggestedActions -> UIMenu? in
            guard let self else { return .none }
            let pinAction = UIAction(
                title: (self.viewModel?.isPinned ?? false)
                ? NSLocalizedString("Unpin", comment: "")
                : NSLocalizedString("Pin", comment: "")
            ) { [ weak self ] _ in
                guard let self else { return }
                self.viewModel?.pinHandler(!(viewModel?.isPinned ?? false))
            }
            
            let editAction = UIAction(
                title: NSLocalizedString("Edit", comment: "")
            ) { [ weak self ] _ in
                guard let self else { return }
                self.viewModel?.editTrackerHandler()
            }
            
            let deleteAction = UIAction(
                title: NSLocalizedString("Delete", comment: ""),
                attributes: .destructive
            ) {  [ weak self ] _ in
                self?.viewModel?.deleteTrackerHandler()
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
}

private extension TrackerCollectionViewCell {
    func correctDaysForm(daysCount: Int) -> String {
        let lastDigit = daysCount % 10
        let lastTwoDigits = daysCount % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "дней"
        } else if lastDigit == 1 {
            return "день"
        } else if lastDigit >= 2 && lastDigit <= 4 {
            return "дня"
        } else {
            return "дней"
        }
    }
}
