//
//  EmojiCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

struct EmogiCellViewModel {
    let emogi: String
    let isSelectedEmoji: Bool
    
    static let empty = EmogiCellViewModel(emogi: "", isSelectedEmoji: false)
}

class EmogiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmogiCell"
    
    var viewModel: EmogiCellViewModel = .empty {
        didSet {
           setup()
        }
    }
    
    private let emogiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(emogiLabel)
        emogiLabel.textAlignment = .center
        emogiLabel.font = UIFont.systemFont(ofSize: .fontSize)
        emogiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emogiLabel.widthAnchor.constraint(equalToConstant: .emogiWidth),
            emogiLabel.heightAnchor.constraint(equalToConstant: .emogiHeight),
            emogiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emogiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setup() {
        emogiLabel.text = viewModel.emogi
        emogiLabel.textAlignment = .center
        if viewModel.isSelectedEmoji {
            backgroundColor = .selected
            layer.cornerRadius = 16
            clipsToBounds = true
        } else {
            backgroundColor = .clear
        }
    }
}

private extension CGFloat {
    static let fontSize = 32.0
    static let emogiWidth = 34.0
    static let emogiHeight = 34.0
}
