//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 11/02/2024.
//

import UIKit

protocol TrackersViewProtocol: AnyObject {
    
}

// MARK: - TrackerViewController
final class TrackersViewController: UIViewController, TrackersViewProtocol {
    
    // MARK: - Properties
    var presenter: TrackersPresenterProtocol?
    
    var currentDate: Date = {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        return date
    }()
    
    // MARK: - UI Components
    private var backgroundView = BackgroundView()
    private var datePicker = UIDatePicker()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPresenter()
    }
    
    // MARK: - View Setup
    private func setupPresenter() {
        let presenter = TrackersPresenter(view: self)
        self.presenter = presenter
    }
    
    private func setupView() {
        view.backgroundColor = .background
        configureNavigationBar()
        configureBackgroundView()
        configureDatePicker()
    }
    
    // MARK: - Private methods
    private func configureNavigationBar() {
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSearchController()
        configureAddTrackerButton()
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureAddTrackerButton() {
        let addTrackerButton = UIBarButtonItem(image: UIImage(named: "plus.button"), style: .plain, target: self, action: #selector(addTracker))
        addTrackerButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func configureBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            backgroundView.widthAnchor.constraint(equalToConstant: 200),
            backgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func addTracker() {
        presenter?.addTracker()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        print("Выбранная дата: \(formattedDate)")
    }
}
