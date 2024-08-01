//
//  EditTrackersViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 01/08/2024.
//

import UIKit

protocol EditTrackerViewProtocol: AnyObject {
    func displayData(model: EditTrackerScreenModel, reloadData: Bool)
    func updateSaveButton(isEnabled: Bool)
}

final class EditTrackerViewController: UIViewController {
    
    typealias TableData = EditTrackerScreenModel.TableData
    
    var presenter: EditTrackerPresenterProtocol!
    
    private lazy var daysCountLabel = UILabel()
    private lazy var cancelButton = UIButton()
    private lazy var saveButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var stackView = UIStackView()
    
    private var screenModel: EditTrackerScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        presenter.setup()
        setupView()
    }
    
    private func setup() {
        title = screenModel.title
        view.backgroundColor = .background
        daysCountLabel.text = NSLocalizedString("\(screenModel.daysCount) days", comment: "")
        updateSaveButton(isEnabled: presenter.isSaveEnabled)
    }
    
    private func setupView() {
        navigationItem.hidesBackButton = true
        setupLabel()
        configureStackView()
        setupTable()
    }
    
    private func setupLabel() {
        view.addSubview(daysCountLabel)
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            daysCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            daysCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            daysCountLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        daysCountLabel.font = .systemFont(ofSize: 32, weight: .bold)
        daysCountLabel.textColor = .navigationBarItem
        daysCountLabel.textAlignment = .center
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: EmojiTableViewCell.reuseIdentifier)
        tableView.register(SubtitledDetailTableViewCell.self, forCellReuseIdentifier: SubtitledDetailTableViewCell.reuseIdentifier)
        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: ColorTableViewCell.reuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: daysCountLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setupSaveButton()
        setupCancelButton()
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        saveButton.backgroundColor = .buttons
        saveButton.layer.cornerRadius = 16
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        cancelButton.layer.cornerRadius = 16
        cancelButton.clipsToBounds = true
        cancelButton.setTitleColor(.tomato, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.tomato.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simpleSection(cells):
            return cells[indexPath.row]
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        DispatchQueue.global().sync {
            presenter.save()
        }
        dismiss(animated: true)
    }
}

//MARK: - EditTrackerViewProtocol

extension EditTrackerViewController: EditTrackerViewProtocol {
    func displayData(model: EditTrackerScreenModel, reloadData: Bool) {
        self.screenModel = model
        if reloadData {
            tableView.reloadData()
        }
    }
    
    func updateSaveButton(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

//MARK: - UITableViewDelegate

extension EditTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            textFieldCell.viewModel = model
            textFieldCell.textField.delegate = self
            cell = textFieldCell
        case let .subtitledCell(model):
            guard let subtitledCell = tableView.dequeueReusableCell(withIdentifier: SubtitledDetailTableViewCell.reuseIdentifier, for: indexPath) as? SubtitledDetailTableViewCell else { return UITableViewCell() }
            subtitledCell.viewModel = model
            cell = subtitledCell
        case let .emogiCell(model):
            guard let emogiCell = tableView.dequeueReusableCell(withIdentifier: EmojiTableViewCell.reuseIdentifier, for: indexPath) as? EmojiTableViewCell else { return UITableViewCell() }
            emogiCell.viewModel = model
            cell = emogiCell
        case let .colorCell(model):
            guard let colorCell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.reuseIdentifier, for: indexPath) as? ColorTableViewCell else { return UITableViewCell() }
            colorCell.viewModel = model
            cell = colorCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else { return UIView() }
        switch screenModel.tableData.sections[section] {
            
        case .simpleSection(_):
            return nil
        case .headeredSection(header: let header, _):
            headerView.titleLabel.text = header
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch screenModel.tableData.sections[section] {
            
        case .simpleSection(_):
            return 0
        case .headeredSection(_, _):
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = tableDataCell(indexPath: indexPath)
        switch cellType {
            
        case .textFieldCell(_):
            return 75
        case .subtitledCell:
            return 75
        case .emogiCell:
            return 150
        case .colorCell:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableDataCell(indexPath: indexPath)
        
        switch cellType {
            
        case let .subtitledCell(model):
            model.action()
        default:
            return
        }
    }
    
}

//MARK: - UITableViewDataSource

extension EditTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simpleSection(cells):
            return cells.count
        case .headeredSection(_, cells: let cells):
            return cells.count
        }
    }
    
}

//MARK: - UITextFieldDelegate

extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
