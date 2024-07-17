//
//  ColorTableViewCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

struct ColorTableViewCellViewModel {
    var action: (UIColor) -> Void
    
    static let empty: ColorTableViewCellViewModel = .init(action: { _ in})
}

final class ColorTableViewCell: UITableViewCell {
    
    var viewModel: ColorTableViewCellViewModel = .empty {
        didSet {
            action = viewModel.action
        }
    }
    
    private var action: (UIColor) -> Void = {  _ in }
    
    private let colors: [UIColor] = [
        .tartOrange, .carrot, .azure, .violette,
        .ufoGreen, .orchid, .palePink, .brilliantAzure,
        .eucalyptus, .cosmicCobalt, .tomato, .paleMagentaPink,
        .macaroniAndCheese, .cornflowerBlue, .blueViolet,
        .mediumOrchid, .mediumPurple, .herbalGreen
    ]
    
    private var selectedIndexPath: IndexPath? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    static let reuseIdentifier = "ColorTableViewCell"
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupCollectionViewConstraints()
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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

//MARK: - UICollectionViewDelegate

extension ColorTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        let color = colors[indexPath.item]
        colorCell.viewModel = ColorCellViewModel(color: color, isSelectedColor: selectedIndexPath == indexPath)
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.item]
        selectedIndexPath = indexPath
        viewModel.action(color)
    }
}

//MARK: - UICollectionViewDataSource

extension ColorTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ColorTableViewCell: UICollectionViewDelegateFlowLayout {
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

