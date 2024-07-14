//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 11/02/2024.
//

import UIKit

protocol TrackersViewProtocol: AnyObject {
    var isFiltering: Bool { get }
    var isSearching: Bool { get }
    var currentDate: Date { get }
    func displayData(model: TrackersScreenModel, reloadData: Bool)
    func showCreateController(viewController: UIViewController)
    func showCompleteTrackerErrorAlert()
}

final class TrackersViewController: UIViewController {
    
    typealias Cell = TrackersScreenModel.CollectionData.Cell
    typealias Section = TrackersScreenModel.CollectionData.Section
    
    private var backgroundView = BackgroundView()
    private let filtersButton = UIButton()
    private let searchController = UISearchController(searchResultsController: nil)
    private var datePicker = UIDatePicker()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var isFiltering: Bool = false
    
    var isSearching: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    var presenter: TrackersPresenterProtocol!
    
    private var model: TrackersScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var currentDate: Date = {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        return date
    }()
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TrackersPresenter(view: self)
        presenter.setup()
        configureView()
        addTapGesture()
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        title = model.title
        filtersButton.setTitle(model.filtersButtonTitle, for: .normal)
        filtersButton.backgroundColor = Assets.Colors.launchBlue
        backgroundView.state = model.emptyState
        updateBackgroundViewVisibility()
        datePicker.date = currentDate
    }
    
    private func configureView() {
        view.backgroundColor = Assets.Colors.background
        configureNavBar()
        configureCollectionView()
        setupFiltersButton()
        setupSearchBar()
        configureDatePicker()
        updateBackgroundViewVisibility()
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func configureNavBar() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        addBarButtonItem.tintColor = model.addBarButtonColor
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func configureBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 200),
            backgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.reuseIdentifier
        )
        
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: .bottomInsets, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupFiltersButtonConstraints() {
        collectionView.addSubview(filtersButton)
        
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.insets),
            filtersButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
    }
    
    private func setupFiltersButton() {
        setupFiltersButtonConstraints()
        
        filtersButton.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        filtersButton.layer.cornerRadius = .cornerRadius
        filtersButton.clipsToBounds = true
    }
    
    private func collectionDataCell(indexPath: IndexPath) -> Cell {
        let section = model.collectionData.sections[indexPath.section]
        switch section {
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
    
    private func updateBackgroundViewVisibility() {
        backgroundView.isHidden = !presenter.shouldShowBackgroundView
        collectionView.isHidden = presenter.shouldShowBackgroundView
        
        if presenter.shouldShowBackgroundView {
            configureBackgroundView()
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAndDeactivateSearch))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - objc methods
    
    @objc private func addAction() {
        presenter.addTracker()
    }
    
    @objc private func filtersButtonTapped() {
        
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        isFiltering = true
        currentDate = sender.date
        presenter.filterTrackers(for: currentDate)
        updateBackgroundViewVisibility()
    }
    
    @objc private func hideKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    @objc private func hideKeyboardAndDeactivateSearch() {
        hideKeyboard()
        if searchController.isActive {
            searchController.isActive = false
        }
    }
}

//MARK: - TrackersViewProtocol

extension TrackersViewController: TrackersViewProtocol {
    func displayData(model: TrackersScreenModel, reloadData: Bool) {
        self.model = model
        if reloadData {
            collectionView.reloadData()
        }
    }
    
    func showCreateController(viewController: UIViewController) {
        let nc = UINavigationController(rootViewController: viewController)
        navigationController?.present(nc, animated: true)
    }
    
    func showCompleteTrackerErrorAlert() {
        let alertController = UIAlertController(
            title: "Ой", message: "Давай сфокусируемся на сегодняшнем дне", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = collectionDataCell(indexPath: indexPath)
        let cell: UICollectionViewCell
        
        switch cellType {
        case let .trackerCell(model):
            guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell
            else { return UICollectionViewCell() }
            trackerCell.viewModel = model
            cell = trackerCell
        }
        return cell
    }
}

//MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.collectionData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model.collectionData.sections[section] {
        case .headeredSection(_, cells: let cells):
            return cells.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as? SupplementaryView else { return UICollectionReusableView() }
            
            switch model.collectionData.sections[indexPath.section] {
            case .headeredSection(header: let header, _):
                headerView.titleLabel.text = header
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth: CGFloat = (Constants.cellsPerRow - 1) * Constants.cellSpacing
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / Constants.cellsPerRow
        return CGSize(width: cellWidth, height: cellWidth * Constants.ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: .headerHeight)
    }
}

//MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if isSearching {
            presenter.showSearchResults(with: searchText)
        } else {
            presenter.showSearchResults(with: "")
        }
        configureView()
    }
}

//MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

private extension CGFloat {
    static let lineSpacing = 9.0
    static let headerHeight = 50.0
    static let cornerRadius = 16.0
    static let insets = 16.0
    static let buttonHeight = 50.0
    static let bottomInsets = 100.0
}

fileprivate struct Constants {
    static let cellsPerRow: CGFloat = 2
    static let insets = 16
    static let cellSpacing: CGFloat = 9
    static let ratio = CGFloat(148) / CGFloat(167)
}
