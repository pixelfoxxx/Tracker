//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 28/02/2024.
//

import UIKit

protocol TrackersPresenterProtocol: AnyObject {
    func setup()
    func addTracker()
}

final class TrackersPresenter {
    
    weak var view: TrackersViewProtocol?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var filteredCategories = [TrackerCategory]()
    
    init(view: TrackersViewProtocol) {
        self.view = view
    }
    
    
}

extension TrackersPresenter: TrackersPresenterProtocol {
    func setup() {
        // TODO: - Create render() method which builds model
    }
    
    func addTracker() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let viewController = self.view as? UIViewController else { return }
            
            let addTrackerVC = AddTrackerViewController()
            let navController = UINavigationController(rootViewController: addTrackerVC)
            viewController.present(navController, animated: true)
        }
    }
}
