//
//  ProfileViewControllerUITests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/19/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest

class ProfileViewControllerUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

        // Start at ListViewController
        XCTAssert(app.navigationBars["Profiles"].exists)

        // Go to ProfileViewController
        app.navigationBars["Profiles"].buttons["+"].tap()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatProfileViewPopsUpAfterPressingPlusButton() {
        XCTAssert(!app.navigationBars["Profiles"].exists)
        XCTAssert(app.scrollViews.count == 1)

        let elements = app.scrollViews.otherElements
        XCTAssert(elements.images["profile_placeholder"].exists)
        XCTAssert(elements.staticTexts["Name:"].exists)
        XCTAssert(elements.staticTexts["Age:"].exists)
        XCTAssert(elements.staticTexts["Gender:"].exists)
        XCTAssert(elements.staticTexts["Hobbies:"].exists)
        XCTAssert(elements.buttons["Dismiss"].exists)
        XCTAssert(elements.buttons["Add Profile"].exists)
        XCTAssert(elements.buttons["  Edit Profile Image  "].exists)
    }

    func testDismissButton() {
        let dismissButton = app.scrollViews.otherElements.buttons["Dismiss"]
        dismissButton.tap()

        // Making sure that the ProfileVC was dismissed
        XCTAssert(app.navigationBars["Profiles"].exists)
        XCTAssert(!dismissButton.exists)
    }

    func testAddProfileButtonWithoutAnyData() {
        let addButton = app.scrollViews.otherElements.buttons["Add Profile"]
        addButton.tap()

        // Making sure that the ProfileVC was not dismissed
        XCTAssert(!app.navigationBars["Profiles"].exists)
        XCTAssert(addButton.exists)
    }

    func testAddProfileButtonWithData() {
        let addButton = app.scrollViews.otherElements.buttons["Add Profile"]
        let textFields = app.scrollViews.otherElements.textFields

        let nameTextField = textFields.element(boundBy: 0)
        nameTextField.tap()
        nameTextField.typeText("Bob")

        let ageTextField = textFields.element(boundBy: 1)
        ageTextField.tap()
        ageTextField.typeText("36")

        let genderTextField = textFields.element(boundBy: 2)
        genderTextField.tap()
        app.pickerWheels["Female"].swipeUp()
        app.pickerWheels["Male"].tap()

        let hobbiesTextField = textFields.element(boundBy: 3)
        hobbiesTextField.tap()
        hobbiesTextField.typeText("cooking, ironing, washing dishes")

        addButton.tap()
        // Making sure that the ProfileVC was dismissed
        XCTAssert(app.navigationBars["Profiles"].exists)
        XCTAssert(!addButton.exists)
    }
}
