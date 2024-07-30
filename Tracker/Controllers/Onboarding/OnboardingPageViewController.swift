//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 29/07/2024.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    
    private lazy var backgroundView = UIImageView()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro", size: 32)
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private var backgroundImage: UIImage
    private var titleString: String
    
    init(
        backgroundImage: UIImage,
        titleString: String
    ) {
        self.backgroundImage = backgroundImage
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupBackgroundView()
        setupLabel()
    }
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backgroundView.image = backgroundImage
    }
    
    private func setupLabel() {
        backgroundView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            label.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            label.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -.insets),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .insets)
        ])
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = titleString
    }
}

fileprivate extension CGFloat {
    static let insets: CGFloat = 16
}
