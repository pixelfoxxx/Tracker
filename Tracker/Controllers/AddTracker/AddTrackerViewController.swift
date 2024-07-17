//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/03/2024.
//

import UIKit

protocol AddTrackerViewProtocol: AnyObject {
    func displayData(model: AddTrackerScreenModel)
    func showCreateActivityController(viewController: UIViewController)
}

final class AddTrackerViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let addEventButton = UIButton()
    private let addHabitButton = UIButton()
    
    var presenter: AddTrackerPresenterProtocol!
    var onCreateTrackerCallback: ((Tracker)->(Void))?
    
    private var model: AddTrackerScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureView()
    }
    
    private func configureView() {
        setupStackView()
        setupAddHabitButton()
        setupAddEventButton()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = .stackViewSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(.insets)),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setup() {
        title = model.title
        view.backgroundColor = model.backgroundColor
        addEventButton.setTitle(model.eventButtonTitle, for: .normal)
        addHabitButton.setTitle(model.habitButtonTitle, for: .normal)
    }
    
    private func setupAddHabitButton() {
        stackView.addArrangedSubview(addHabitButton)
        addHabitButton.backgroundColor = .buttons
        addHabitButton.layer.cornerRadius = .cornerRadius
        addHabitButton.clipsToBounds = true
        
        addHabitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addHabitButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        
        addHabitButton.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
    }
    
    private func setupAddEventButton() {
        stackView.addArrangedSubview(addEventButton)
        addEventButton.backgroundColor = .buttons
        addEventButton.layer.cornerRadius = .cornerRadius
        addEventButton.clipsToBounds = true
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addEventButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        
        addEventButton.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
    }
    
    @objc private func addHabit() {
        presenter.addHabit()
    }
    
    @objc private func addEvent() {
        presenter.addEvent()
    }
}

extension AddTrackerViewController: AddTrackerViewProtocol {
    func displayData(model: AddTrackerScreenModel) {
        self.model = model
    }
    
    func showCreateActivityController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension CGFloat {
    static let insets: CGFloat = 20
    static let cornerRadius: CGFloat = 16
    static let buttonHeight: CGFloat = 60
    static let stackViewSpacing: CGFloat = 16
}
