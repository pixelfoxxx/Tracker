//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import UIKit

protocol CreateCategoryViewProtocol: AnyObject {
    func displayData(model: CreateCategoryScreenModel, reloadData: Bool)
    func updateSaveButton(isEnabled: Bool)
}

final class CreateCategoryViewController: UIViewController {
    
    typealias TableData = CreateCategoryScreenModel.TableData
    
    var presenter: CreateCategoryPresenterProtocol!
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var saveButton = UIButton()
    private var screenModel: CreateCategoryScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        setupView()
    }
    
    private func setup() {
        title = screenModel.title
        saveButton.setTitle(screenModel.doneButtonTitle, for: .normal)
        updateSaveButton(isEnabled: presenter.isSaveEnabled)
    }
    
    private func setupView() {
        view.backgroundColor = .background
        navigationItem.hidesBackButton = true
        setupButton()
        configureTableView()
    }
    
    private func setupButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.insets),
            saveButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        
        saveButton.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        saveButton.backgroundColor = .buttons
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = .cornerRadius
        saveButton.clipsToBounds = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.backgroundColor = .background
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -.insets)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        switch screenModel.tableData.sections[indexPath.section] {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
    
    @objc private func saveCategory() {
        updateSaveButton(isEnabled: false)
        DispatchQueue.global().sync {
            presenter.saveCategory()
        }
        updateSaveButton(isEnabled: true)
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: CreateCategoryViewProtocol

extension CreateCategoryViewController: CreateCategoryViewProtocol {
    func updateSaveButton(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func displayData(model: CreateCategoryScreenModel, reloadData: Bool) {
        screenModel = model
        if reloadData {
            tableView.reloadData()
        }
    }
}

//MARK: UITableViewDelegate

extension CreateCategoryViewController: UITableViewDelegate {
    
}

//MARK: UITableViewDataSource

extension CreateCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        var cell: UITableViewCell
        
        switch cellType {
        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            textFieldCell.viewModel = model
            cell = textFieldCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple( cells):
            return cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .cellHeight
    }
}

private extension CGFloat {
    static let cornerRadius = 16.0
    static let insets = 20.0
    static let buttonHeight = 60.0
    static let cellHeight = 60.0
}

