//
//  FLOUITests.swift
//  FLOUITests
//
//  Created by 심영민 on 6/24/24.
//

import XCTest

final class FLOUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
    
    func test_UITesting_onTapAnchorButton(app : XCUIApplication, anchorButton: String) {
        let anchor = app.buttons[anchorButton]
        XCTAssert(anchor.waitForExistence(timeout: 5))
        
        anchor.tap()
        sleep(1)
    }
    
    func test_UITesting_onTapMusicCell(app: XCUIApplication) {
        let cell = app.collectionViews.firstMatch
        cell.tap()
        sleep(1)
    }
    
    func test_UITesting_onTapDismissButton(app: XCUIApplication) {
        let dismissButton = app.buttons["dismissButton"]
        XCTAssert(dismissButton.waitForExistence(timeout: 5))
        
        dismissButton.tap()
        sleep(1)
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Anchor 누를 시 Scroll 확인
        test_UITesting_onTapAnchorButton(app: app, anchorButton: "장르/테마")
        test_UITesting_onTapAnchorButton(app: app, anchorButton: "오디오")
        test_UITesting_onTapAnchorButton(app: app, anchorButton: "영상")
        test_UITesting_onTapAnchorButton(app: app, anchorButton: "차트")
        
        // TrackDetail 화면 이동 확인
        test_UITesting_onTapMusicCell(app: app)
        
        // TrackDetail Dismiss 확인
        test_UITesting_onTapDismissButton(app: app)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
