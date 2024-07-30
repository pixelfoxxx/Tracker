//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 29/07/2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var onboardingPages: [UIViewController] = {
        let page1 = OnboardingPageViewController(
            backgroundImage: Assets.Images.Onboarding.firstScreen ?? UIImage(),
            titleString: "Отслеживайте только то, что хотите"
        )
        let page2 = OnboardingPageViewController(
            backgroundImage: Assets.Images.Onboarding.secondScreen ?? UIImage(),
            titleString: "Даже если это не литры воды и йога"
        )
        return [page1, page2]
    }()
    
    private lazy var customPageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = onboardingPages.count
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .buttons
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = .radius
        button.clipsToBounds = true
        button.backgroundColor = .buttons
        button.setTitle(NSLocalizedString("Вот это технологии!", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(navigateToMainScreen), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        finishOnboarding()
        initializeFirstPage()
        setupUIComponents()
    }
    private func finishOnboarding() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "hasSeenOnboarding")
        
        // Переход на основной экран
        let mainViewController = TabBarViewController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = mainViewController
        }
    }
    private func initializeFirstPage() {
        if let firstPage = onboardingPages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupUIComponents() {
        setupActionButton()
        setupPageControl()
    }
    
    private func setupPageControl() {
        view.addSubview(customPageControl)
        NSLayoutConstraint.activate([
            customPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customPageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -.pageControlBottomPadding)
        ])
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .sidePadding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.sidePadding),
            actionButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.buttonBottomPadding)
        ])
    }
    
    @objc private func navigateToMainScreen() {
        let mainTabBarVC = TabBarViewController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = onboardingPages.firstIndex(of: currentVC) {
            customPageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingPages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return onboardingPages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingPages.firstIndex(of: viewController), index < onboardingPages.count - 1 else {
            return nil
        }
        return onboardingPages[index + 1]
    }
}

private extension CGFloat {
    static let radius: CGFloat = 16
    static let buttonHeight: CGFloat = 60
    static let sidePadding: CGFloat = 20
    static let buttonBottomPadding: CGFloat = 50
    static let pageControlBottomPadding: CGFloat = 24
}
