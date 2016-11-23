//
//  MenuViewControllerUITests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/22/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest

class MenuViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    let menuButton = XCUIApplication().buttons["Menu ☰"]

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

        // Start at ListViewController
        XCTAssert(app.otherElements["InfoView"].exists)
        XCTAssert(app.buttons["Profiles App"].exists)
        XCTAssert(app.buttons["Menu ☰"].exists)
    }
    
    override func tearDown() {
        menuButton.tap()
        app.buttons["Clear ⚤ or ⬆︎⬇︎"].tap()

        super.tearDown()
    }
    
    func testUpdatingInfoLabelOnFemaleFilter() {
        menuButton.tap()
        app.buttons["Female"].tap()
        waitForElementToAppear(element: app.buttons["👩"])
    }

    func testUpdatingInfoLabelOnMaleFilter() {
        menuButton.tap()
        app.buttons["Male"].tap()
        waitForElementToAppear(element: app.buttons["👦"])
    }

    func testUpdatingInfoLabelOnAgeSort() {
        menuButton.tap()
        app.buttons["AgeSort"].tap()
        waitForElementToAppear(element: app.buttons["Age ⬆︎"])

        menuButton.tap()
        app.buttons["AgeSort"].tap()
        waitForElementToAppear(element: app.buttons["Age ⬇︎"])

        menuButton.tap()
        app.buttons["AgeSort"].tap()
        waitForElementToAppear(element: app.buttons["Profiles App"])
    }

    func testUpdatingInfoLabelOnNameSort() {
        menuButton.tap()
        app.buttons["Name"].tap()
        waitForElementToAppear(element: app.buttons["Name ⬆︎"])

        menuButton.tap()
        app.buttons["NameSort"].tap()
        waitForElementToAppear(element: app.buttons["Name ⬇︎"])

        menuButton.tap()
        app.buttons["NameSort"].tap()
        waitForElementToAppear(element: app.buttons["Profiles App"])
    }

    func testUpdatingInfoLabelOnNameSortWhenAgeSortIsSelected() {
        menuButton.tap()
        app.buttons["AgeSort"].tap()
        waitForElementToAppear(element: app.buttons["Age ⬆︎"])

        menuButton.tap()
        app.buttons["NameSort"].tap()
        waitForElementToAppear(element: app.buttons["Name ⬆︎"])
    }

    func testUpdatingInfoLabelOnAgeSortAndGenderFilter() {
        menuButton.tap()
        app.buttons["NameSort"].tap()
        waitForElementToAppear(element: app.buttons["Name ⬆︎"])

        menuButton.tap()
        app.buttons["Female"].tap()
        waitForElementToAppear(element: app.buttons["👩 Name ⬆︎"])

        menuButton.tap()
        app.buttons["NameSort"].tap()
        waitForElementToAppear(element:  app.buttons["👩 Name ⬇︎"])

        menuButton.tap()
        app.buttons["Clear ⚤ or ⬆︎⬇︎"].tap()
        waitForElementToAppear(element: app.buttons["Profiles App"])
    }


    // MARK: Test helper method(s)
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")

        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}
