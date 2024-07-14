//
//  CreateActivityViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 14/07/2024.
//

import UIKit

protocol CreateActivityViewProtocol: AnyObject {
    func displayData(screenModel: CreateActivityScreenModel, reloadTableData: Bool)
    func showController(vc: UIViewController)
    func updateSaveButton(isEnabled: Bool)
}

final class CreateActivityViewController: UIViewController {
    
    typealias TableData = CreateActivityScreenModel.TableData
    
    private lazy var stackView = UIStackView()
    private lazy var cancelButton = UIButton()
    private lazy var createButton = UIButton()
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var presenter: CreateActivityPresenterProtocol!
    
    private var screenModel: CreateActivityScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        presenter.setup()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setup()
    }
    
    private func setup() {
        title = screenModel.title
        view.backgroundColor = .background
        createButton.setTitle(screenModel.createButtonTitle, for: .normal)
        cancelButton.setTitle(screenModel.cancelButtonTitle, for: .normal)
        updateSaveButton(isEnabled: presenter.isSaveEnabled)
    }
    
    private func configureView() {
        configureStackView()
        setupTableView()
        navigationItem.hidesBackButton = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> TableData.Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        case .headered(_, cells: let cells):
            return cells[indexPath.row]
        }
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        
        setupCreateButton()
        setupCancelButton()
    }
    
    private func setupCreateButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        createButton.backgroundColor = .buttons //MARK: - TODO set color and restrict UI
        createButton.layer.cornerRadius = .cornerRadius
        createButton.clipsToBounds = true
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
        cancelButton.layer.cornerRadius = .cornerRadius
        cancelButton.clipsToBounds = true
        cancelButton.setTitleColor(.tomato, for: .normal)
        cancelButton.layer.borderWidth = .borderWidth
        cancelButton.layer.borderColor = UIColor.tomato.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        presenter.createActivity(for: presenter.selectedDate)
        navigationController?.dismiss(animated: true)
    }
}


//MARK: - CreateActivityViewProtocol

extension CreateActivityViewController: CreateActivityViewProtocol {
    
    func displayData(screenModel: CreateActivityScreenModel, reloadTableData: Bool) {
        self.screenModel = screenModel
        if reloadTableData {
            tableView.reloadData()
        }
    }
    
    func showController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSaveButton(isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

//MARK: - UITableViewDelegate

extension CreateActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
       
        switch cellType {
            
        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            textFieldCell.viewModel = model
            textFieldCell.textField.delegate = self
            cell = textFieldCell
        case let .detailCell(model):
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: SubtitledDetailTableViewCell.reuseIdentifier, for: indexPath) as? SubtitledDetailTableViewCell else { return UITableViewCell() }
            detailCell.viewModel = model
            cell = detailCell
        case let .emojiCell(model):
            guard let emojiCell = tableView.dequeueReusableCell(withIdentifier: EmojiTableViewCell.reuseIdentifier, for: indexPath) as? EmojiTableViewCell else { return UITableViewCell() }
            emojiCell.viewModel = model
            cell = emojiCell
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
            
        case .simple(_):
            return nil
        case .headered(header: let header, _):
            headerView.titleLabel.text = header
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch screenModel.tableData.sections[section] {
            
        case .simple(_):
            return 0
        case .headered(_, _):
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = tableDataCell(indexPath: indexPath)
        switch cellType {
            
        case .textFieldCell(_):
            return 75
        case .detailCell(_):
            return 75
        case .emojiCell:
            return 150
        case .colorCell:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableDataCell(indexPath: indexPath)
        
        switch cellType {
            
        case let .detailCell(model):
            model.action()
        default:
            return
        }
    }
}

//MARK: - UITableViewDataSource

extension CreateActivityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        case .headered(_, cells: let cells):
            return cells.count
        }
    }
}

//MARK: - UITextFieldDelegate

extension CreateActivityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension CGFloat {
    static let headerHeight = 50.0
    static let interItemSpacing = 5.0
    static let itemWidthHeight = 52.0
    static let cornerRadius = 16.0
    static let buttonHeight = 60.0
    static let borderWidth = 1.0
    static let insets = 16.0
    static let collectionViewTopSpacing = 32.0
}
