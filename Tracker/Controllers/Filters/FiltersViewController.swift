//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 31/07/2024.
//

import UIKit

protocol FiltersViewProtocol: AnyObject {
    func displayData(model: FiltersScreenModel, reloadData: Bool)
}

final class FiltersViewController: UIViewController {
    
    typealias TableData = FiltersScreenModel.TableData
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var presenter: FiltersPresenterProtocol!
    
    private var screenModel: FiltersScreenModel = .empty {
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
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .background
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
}

extension FiltersViewController: FiltersViewProtocol {
    func displayData(model: FiltersScreenModel, reloadData: Bool) {
        screenModel = model
        if reloadData {
            tableView.reloadData()
        }
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .filterCell(model):
            guard let filterCell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
                return UITableViewCell() }
            filterCell.viewModel = model
            cell = filterCell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = tableDataCell(indexPath: indexPath)
        switch cellModel {
        case .filterCell(var model):
            model.isSelected.toggle()
            DispatchQueue.global().sync {
                model.selectFilter(model.filter)
            }
        }
        dismiss(animated: true)
    }
}
