//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol CategoryViewProtocol: AnyObject {
    func displayData(model: CategoryScreenModel, reloadData: Bool)
}

final class CategoryViewController: UIViewController {
    
    typealias TableData = CategoryScreenModel.TableData
    
    var presenter: CategoryPresenterProtocol!
    
    private var model: CategoryScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var button = UIButton()
    private var backgroundView = BackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        setupView()
    }
}

//MARK: - CategoryViewProtocol

extension CategoryViewController: CategoryViewProtocol {
    func displayData(model: CategoryScreenModel, reloadData: Bool) {
        self.model = model
        if reloadData {
            tableView.reloadData()
        }
    }
}

//MARK: - TableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.global().sync {
            presenter.chooseCategory(index: indexPath.row)
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        var cell: UITableViewCell
        
        switch cellType {
        case let .labledCell(model):
            guard let labledCell = tableView.dequeueReusableCell(withIdentifier: LabeledCell.reuseIdentifier, for: indexPath) as? LabeledCell else { return UITableViewCell() }
            labledCell.viewModel = model
            cell = labledCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case let .simpleSection(cells):
            return cells.count
        }
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
    }
    
    func setup() {
        title = model.title
        view.backgroundColor = .background
        button.setTitle(model.buttonTitle, for: .normal)
        updateBackgroundViewVisiability()
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
        presenter.addCategory()
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
        backgroundView.isHidden = !presenter.shouldShowBackgroundView
        tableView.isHidden = presenter.shouldShowBackgroundView

        if presenter.shouldShowBackgroundView {
            configureBackgroundView()
        }
    }
    
    func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        switch model.tableData.sections[indexPath.section] {
        case let .simpleSection(cells):
            return cells[indexPath.row]
        }
    }
}


private extension CGFloat {
    static let cornerRadius = 16.0
    static let insets = 20.0
    static let buttonHeight = 60.0
    static let cellHeight = 60.0
}
