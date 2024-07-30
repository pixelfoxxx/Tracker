//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol CategoryViewProtocol: AnyObject {}

final class CategoryViewController: UIViewController {
    
    var viewModel: CategoryViewModelProtocol!
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var button = UIButton()
    private var backgroundView = BackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.setup()
        setupView()
    }
}

//MARK: - TableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.global().sync {
            viewModel.chooseCategory(index: indexPath.row)
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.tableDataCell(indexPath: indexPath)
        var cell: UITableViewCell
        
        switch cellType {
        case let .labledCell(model):
            guard let labeledCell = tableView.dequeueReusableCell(withIdentifier: LabeledCell.reuseIdentifier, for: indexPath) as? LabeledCell else { return UITableViewCell() }
            labeledCell.viewModel = model
            cell = labeledCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .cellHeight
    }
    
}

private extension CategoryViewController {
    
    func setupView() {
        setupButton()
        configureTableView()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .background
    }
    
    func setup() {
        viewModel.onDataChange = { [ weak self ] model in
            guard let self else { return }
            self.title = model.title
            self.button.setTitle(model.buttonTitle, for: .normal)
            self.tableView.reloadData()
            updateBackgroundViewVisiability()
        }
    }
    
    func setupButton() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.insets),
            button.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        
        button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        button.backgroundColor = .buttons
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = .cornerRadius
        button.clipsToBounds = true
    }
    
    @objc private func addCategory() {
        viewModel.addCategory()
        updateBackgroundViewVisiability()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LabeledCell.self, forCellReuseIdentifier: LabeledCell.reuseIdentifier)
        tableView.backgroundColor = .background
        setupTableViewConstraints()
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -.insets)
        ])
    }
    
    func configureBackgroundView() {
        backgroundView.state = .emptyCategories
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 200),
            backgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func updateBackgroundViewVisiability() {
        backgroundView.isHidden = !viewModel.shouldShowBackgroundView
        tableView.isHidden = viewModel.shouldShowBackgroundView

        if viewModel.shouldShowBackgroundView {
            configureBackgroundView()
        }
    }
}

extension CategoryViewController: CategoryViewProtocol {}


private extension CGFloat {
    static let cornerRadius = 16.0
    static let insets = 20.0
    static let buttonHeight = 60.0
    static let cellHeight = 60.0
}
