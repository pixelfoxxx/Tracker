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
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Assets.Colors.background
        
        let trackerVC = TrackersViewController()
        trackerVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Trackers", comment: ""), image: UIImage(systemName: "record.circle"), selectedImage: UIImage(systemName: "record.circle.fill"))
        
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Statistic", comment: ""), image: UIImage(systemName: "hare.fill"), selectedImage: UIImage(systemName: "hare.fill"))
        
        let trackerNavController = UINavigationController(rootViewController: trackerVC)
        let statsNavController = UINavigationController(rootViewController: statsVC)
        
        viewControllers = [trackerNavController, statsNavController]
    }
}
