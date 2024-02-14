//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 11/02/2024.
//

import UIKit

// MARK: - TrackerViewController
final class TrackerViewController: UIViewController {
    
    // MARK: - UI Components
    private var backgroundView = BackgroundView()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = Date()
        return datePicker
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - View Setup
    private func setupView() {
        view.backgroundColor = .ypWhite
        configureNavigationBar()
        configureBackgroundView()
    }
    
    private func configureNavigationBar() {
        let navBarTitle = "Трекеры"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let addTrackerButton = UIBarButtonItem(
            image: UIImage(named: "plus.button"),
            style: .plain,
            target: self,
            action: #selector(addTracker)
        )
        
        navigationItem.title = navBarTitle
        navigationItem.leftBarButtonItem = addTrackerButton
        addTrackerButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addTracker() {
        // TODO: - Move this logic to presenter
        print("Add new Tracker")
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
}
