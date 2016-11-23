//
//  SAFSettingsTests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/22/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest
@testable import ProfilesApp

class SAFSettingsTests: XCTestCase {

    let settings = SAFSettings.sharedInstance

    func testResetingAgeSortOnNameSortBeingSet() {
        XCTAssert(settings.ageSortSetting == .None)
        XCTAssert(settings.ageSortSetting == .None)

        settings.ageSortSetting = .Ascending
        settings.nameSortSetting = .Ascending

        XCTAssert(settings.ageSortSetting == .None)
        XCTAssert(settings.nameSortSetting == .Ascending)
    }
    func testResetingNameSortOnAgeSortBeingSet() {
        XCTAssert(settings.ageSortSetting == .None)
        XCTAssert(settings.ageSortSetting == .None)

        settings.nameSortSetting = .Descending
        settings.ageSortSetting = .Ascending

        XCTAssert(settings.nameSortSetting == .None)
        XCTAssert(settings.ageSortSetting == .Ascending)
    }
}
