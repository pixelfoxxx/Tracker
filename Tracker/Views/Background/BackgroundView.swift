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
        case emptyCategories
        case empty
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let imageView:  UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
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
            setupConstraints()
            setupUI()
        }
        
        private func setupConstraints() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 80.0),
                imageView.heightAnchor.constraint(equalToConstant: 80.0),
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                
                textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
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
        case .emptyCategories:
            configureCategoriesDoNonExistState()
        }
    }
    
    private func configureTrackersDoNotExistState() {
        imageView.image = Assets.Images.Background.emptyTrackers
        textLabel.text = NSLocalizedString("What are we gonna track?", comment: "")
    }
    
    private func configureCategoriesDoNonExistState() {
        imageView.image = Assets.Images.Background.emptyTrackers
        textLabel.text = NSLocalizedString("Habits and events can be combined by meaning", comment: "")
    }
    
    private func configureEmptyStatisticState() {
        imageView.image = Assets.Images.Background.emptyStatistic
        textLabel.text = NSLocalizedString("There's nothing to analyse yet", comment: "")
    }
    
    private func configureEmptySearchResultsState() {
        imageView.image = Assets.Images.Background.emptySearchResults
        textLabel.text = NSLocalizedString("Nothing found", comment: "")
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
