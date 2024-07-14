//
//  ColorCell.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

struct ColorCellViewModel {
    let color: UIColor
    var isSelectedColor: Bool
    
    static let empty = ColorCellViewModel(color: .clear, isSelectedColor: false)
}

class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    private let colorView = UIView()
    
    var viewModel: ColorCellViewModel = .empty {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        colorView.layer.cornerRadius = .cornerRadius
        colorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: .colorViewWidthHeight),
            colorView.heightAnchor.constraint(equalToConstant: .colorViewWidthHeight),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setup() {
        colorView.backgroundColor = viewModel.color
        if viewModel.isSelectedColor {
            layer.borderWidth = 3
            layer.borderColor = viewModel.color.withAlphaComponent(0.3).cgColor
            layer.cornerRadius = 16
            clipsToBounds = true
        } else {
            layer.borderWidth = 0
        }
    }
}

private extension CGFloat {
    static let cornerRadius = 8.0
    static let colorViewWidthHeight = 40.0
}
