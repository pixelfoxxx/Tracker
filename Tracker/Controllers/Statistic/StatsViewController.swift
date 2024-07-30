//
//  StatsViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 11/02/2024.
//

import UIKit

protocol StatisticViewProtocol: AnyObject {
    func displayData(model: StatisticScreenModel)
}

final class StatsViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 12
        return stack
    }()
    
    private lazy var bestPeriodView = StatisticElementView()
    private lazy var perfectDaysView = StatisticElementView()
    private lazy var completedTrackersView = StatisticElementView()
    private lazy var avarageValueView = StatisticElementView()
    
    var presenter: StatisticPresenterProtocol!
    
    private var screenModel: StatisticScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = StatisticPresenter(view: self)
        presenter.setup()
        configureView()
        setupView()
    }
    
    private func configureView() {
        view.backgroundColor = Assets.Colors.background
    }
    
    private func setup() {
        title = screenModel.title
        
        _ = screenModel.statisticData.items.map {
            switch $0 {
            case let .bestPeriod(model):
                configureBestPeriodView(model: model)
            case let .bestDays(model):
                configureBestDaysView(model: model)
            case let .completed(model):
                configureCompletedView(model: model)
            case let .avarage(model):
                configureAvarageView(model: model)
            }
        }
    }
    
    private func setupView() {
        setupStack()
    }
    
    private func setupStack() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(bestPeriodView)
        stackView.addArrangedSubview(perfectDaysView)
        stackView.addArrangedSubview(completedTrackersView)
        stackView.addArrangedSubview(avarageValueView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func configureBestPeriodView(model: StatisticElementViewModel) {
        bestPeriodView.model = model
    }
    
    private func configureBestDaysView(model: StatisticElementViewModel) {
        perfectDaysView.model = model
    }
    
    private func configureCompletedView(model: StatisticElementViewModel) {
        completedTrackersView.model = model
    }
    
    private func configureAvarageView(model: StatisticElementViewModel) {
        avarageValueView.model = model
    }
}

//MARK: - StatisticViewProtocol

extension StatsViewController: StatisticViewProtocol {
    func displayData(model: StatisticScreenModel) {
        self.screenModel = model
    }
}
