//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Юрий Клеймёнов on 30/07/2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        isRecording = false // Do not forget set to true when first test launch, and then set false. Snapshot tests work.
    }

    func testViewControllerLightMode() {
        let vc = TabBarViewController()
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX, traits: .init(userInterfaceStyle: .light)), testName: "ViewControllerLightMode")
    }

    func testViewControllerDarkMode() {
        let vc = TabBarViewController()
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX, traits: .init(userInterfaceStyle: .dark)), testName: "ViewControllerDarkMode")
    }

}
