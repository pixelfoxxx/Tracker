//
//  BackgroundView.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 14/02/2024.
//

import UIKit

final class BackgroundView: UIView {
    enum BackgroundState {
        case emptyStatistic
        case emptySearchResult
        case trackersDoNotExist
        case empty
    }
    
    private let imageView:  UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "YS-Display-Medium", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    var state: BackgroundState = .empty {
        didSet {
            configure()
        }
    }
    
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
        setupUI()
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: .imageViewWidth),
            imageView.heightAnchor.constraint(equalToConstant: .imageViewHeight)
        ])
    }
    
    private func setupTextLabelConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .insets),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: .textLabelHeight)
        ])
    }
    
    private func setupUI() {
        switch state {
        case .emptyStatistic:
            configureEmptyStatisticState()
        case .emptySearchResult:
            configureEmptySearchResultsState()
        case .trackersDoNotExist:
            configureTrackersDoNotExistState()
        case .empty:
            configureEmptyState()
        }
    }
    
    private func configureTrackersDoNotExistState() {
        imageView.image = Assets.Images.Background.emptyTrackers
        textLabel.text = "Что будем отслеживать?"
    }
    
    private func configureEmptyStatisticState() {
        imageView.image = Assets.Images.Background.emptyStatistic
        textLabel.text = "Анализировать пока нечего"
    }
    
    private func configureEmptySearchResultsState() {
        imageView.image = Assets.Images.Background.emptySearchResults
        textLabel.text = "Ничего не найдено"
    }
    
    private func configureEmptyState() {
        imageView.image = nil
        textLabel.text = nil
    }
}

private extension CGFloat {
    static let imageViewWidth = 80.0
    static let imageViewHeight = 80.0
    static let insets = 8.0
    static let textLabelHeight = 20.0
}
