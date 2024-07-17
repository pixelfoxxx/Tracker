//
//  EmojiTableViewCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

struct EmojiTableViewCellViewModel {
    var action: ((String) ->Void)
    
    static let empty: EmojiTableViewCellViewModel = .init(action: { _ in })
}

final class EmojiTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EmojiTableViewCell"
    
    var action: ((String) ->Void) = { _ in }
    
    var viewModel: EmojiTableViewCellViewModel = .empty {
        didSet {
            self.action = viewModel.action
        }
    }
    
    private var selectedIndexPath: IndexPath? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let emogis: [String] = [
        "🙂", "😻", "🌺",
        "🐶", "❤️", "😱",
        "😇", "😡", "🥶",
        "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇",
        "🎸", "🏝", "😪"
    ]
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        collectionView.register(EmogiCell.self, forCellWithReuseIdentifier: EmogiCell.reuseIdentifier)
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        setupCollectionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }
    
    private func setupCollectionViewConstraints() {
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//MARK: UICollectionViewDelegate
extension EmojiTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let emogiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmogiCell.reuseIdentifier, for: indexPath) as? EmogiCell else { return UICollectionViewCell() }
        let emogi = emogis[indexPath.item]
        
        emogiCell.viewModel = EmogiCellViewModel(emogi: emogi, isSelectedEmoji: selectedIndexPath == indexPath)
        return emogiCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emogi = emogis[indexPath.item]
        selectedIndexPath = indexPath
        viewModel.action(emogi)
    }
}

//MARK: - UICollectionViewDataSource

extension EmojiTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emogis.count
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension EmojiTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: .itemWidthHeight, height: .itemWidthHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

private extension CGFloat {
    static let interItemSpacing = 5.0
    static let itemWidthHeight = 52.0
}
