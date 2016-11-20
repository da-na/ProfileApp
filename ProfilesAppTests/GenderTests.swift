//
//  GenderTests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/19/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest
@testable import ProfilesApp

class GenderTests: XCTestCase {

    func testGenderAllValues() {
        let values = Gender.allValues()
        XCTAssert(values == ["Female","Male"])
    }

    func testGenderMappingValues() {
        let values = Gender.allValues()
        let genders: [Gender] = values.map{ Gender(rawValue: $0)! }
        let descriptions = genders.map{ $0.description }
        XCTAssert(values == descriptions)
    }
}
