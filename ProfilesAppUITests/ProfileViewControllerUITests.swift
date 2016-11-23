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
        XCTAssert(app.otherElements["InfoView"].exists)
        XCTAssert(app.buttons["Profiles App"].exists)
        XCTAssert(app.buttons["Menu ☰"].exists)

        // Go to ProfileViewController
        app.buttons["Menu ☰"].tap()
        app.buttons["Add New Profile"].tap()
    }

    func testThatProfileViewPopsUpAfterPressingPlusButton() {
        waitForElementToAppear(element: app.otherElements["ProfileView"])

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
        XCTAssert(!app.otherElements["ProfileView"].exists)
        XCTAssert(!dismissButton.exists)
    }

    func testAddProfileButtonWithoutAnyData() {
        let addButton = app.scrollViews.otherElements.buttons["Add Profile"]
        addButton.tap()

        // Making sure that the ProfileVC was not dismissed
        XCTAssert(app.otherElements["ProfileView"].exists)
        XCTAssert(addButton.exists)
    }

    func testAddProfileButtonWithDataAndEditHobbies() {
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
        let hobbies = "cooking, ironing, washing dishes"
        hobbiesTextField.tap()
        hobbiesTextField.typeText(hobbies)

        addButton.tap()

        // Making sure that the ProfileVC was dismissed
        XCTAssert(!app.otherElements["ProfileView"].exists)
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


