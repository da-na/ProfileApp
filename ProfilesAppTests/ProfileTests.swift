//
//  ProfileTests.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/19/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import XCTest
import Firebase
@testable import ProfilesApp

class ProfileTests: XCTestCase {

    let testProfile: Profile

    override init(){
        let name = "Kathy"
        let gender: Gender = .Female
        let age = 27
        let backgroundColor = UIColor.green
        let hobbies: [String] = ["Traveling","Meeting new people","Photography"]

        testProfile = Profile(name: name, gender: gender, age: age, backgroundColor: backgroundColor, profileImage: nil, hobbies: hobbies)

        super.init()
    }

    func testCreatingProfileFromSnapshot() {
        let snapshotMock = FIRDataSnapshotMock(value: testProfile.toAnyObject(), ref: FIRDatabaseReference())
        let newProfile = Profile(snapshot: snapshotMock)

        XCTAssert(newProfile.uid == testProfile.uid)
        XCTAssert(newProfile.name == testProfile.name)
        XCTAssert(newProfile.gender == testProfile.gender)
        XCTAssert(newProfile.age == testProfile.age)
        XCTAssert(newProfile.backgroundColor == testProfile.backgroundColor)
        XCTAssert(newProfile.hobbies == testProfile.hobbies)
    }
}

fileprivate class FIRDataSnapshotMock: DataSnapshotProtocol {
    var value: Any?
    var ref: FIRDatabaseReference

    init(value: Any?, ref: FIRDatabaseReference){
        self.value = value
        self.ref = ref
    }
}
