//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 20.02.2024.
//  
//

import UIKit

protocol ScheduleViewProtocol: AnyObject {
    func displayData(model: ScheduleScreenModel, reloadData: Bool)
}

final class ScheduleViewController: UIViewController {
    
    typealias TableData = ScheduleScreenModel.TableData
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var presenter: SchedulePresenterProtocol!
    
    private var screenModel: ScheduleScreenModel = .empty {
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
        setupTableView()
        setupTableViewConstraints()
        view.backgroundColor = .background
        navigationItem.hidesBackButton = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        tableView.register(LabledCell.self, forCellReuseIdentifier: LabledCell.reuseIdentifier)
        tableView.backgroundColor = .background
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        switch screenModel.tableData.sections[indexPath.section] {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }
}

//MARK: - ScheduleViewProtocol

extension ScheduleViewController: ScheduleViewProtocol {
    func displayData(model: ScheduleScreenModel, reloadData: Bool) {
        self.screenModel = model
        if reloadData {
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
}

//MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .switchCell(model):
            guard let switchCell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as? SwitchCell else { return UITableViewCell() }
            switchCell.viewModel = model
            switchCell.selectionStyle = .none
            cell = switchCell
        case let .labledCell(model):
            guard let labledCell = tableView.dequeueReusableCell(withIdentifier: LabledCell.reuseIdentifier, for: indexPath) as? LabledCell else { return UITableViewCell() }
            labledCell.viewModel = model
            cell = labledCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableDataCell(indexPath: indexPath)
        
        switch cellType {
        
        case .labledCell(_):
            presenter.saveSchedule()
            navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
}
