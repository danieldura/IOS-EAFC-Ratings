//
//  EAFC_RatingsUITests.swift
//  EAFC RatingsUITests
//
//  Created by Daniel Dura on 25/2/26.
//

import XCTest

final class EAFCRatingsUITests: XCTestCase {
    @MainActor
    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
