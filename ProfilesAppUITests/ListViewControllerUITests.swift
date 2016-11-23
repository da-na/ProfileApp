//
//  ListViewControllerUITests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/22/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest

class ListViewControllerUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

        // Start at ListViewController
        XCTAssert(app.otherElements["InfoView"].exists)
        XCTAssert(app.cells.count > 0, "This test suite requires at least one profile! Please add a profile to the app, so it can be tested")
    }

    func testProfileEdit() {
        XCTAssert(!app.otherElements["ProfileView"].exists)

        let cellForEditing = app.tables.children(matching: .cell).element(boundBy: 0)
        cellForEditing.tap()

        XCTAssert(app.otherElements["ProfileView"].exists)
    }

    func testProfileRemoval() {
        let amount = app.cells.count
        let cellForRemoval = app.tables.children(matching: .cell).element(boundBy: amount - 1)
        cellForRemoval.swipeLeft()
        app.tables.buttons["✘"].tap()

        XCTAssert(amount > app.cells.count)
    }
}
