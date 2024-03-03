//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 11/02/2024.
//

import UIKit

// MARK: - TabBarViewController
final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        setupTabBar()
    }
}

extension TabBarViewController {
    private func setupTabBar() {
        // MARK: - TabBar Properties
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .ypWhite
        
        // MARK: - TabBar ViewControllers
        let trackerVC = TrackersViewController()
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers.tab"),
            selectedImage: nil)
        
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats.tab"),
            selectedImage: nil)
        
        let trackerNavController = UINavigationController(rootViewController: trackerVC)
        let statsNavController = UINavigationController(rootViewController: statsVC)
        
        viewControllers = [trackerNavController, statsNavController]
    }
}
