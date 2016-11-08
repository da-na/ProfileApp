//
//  Profile.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import Firebase

class Profile {
    let uid: Int
    let ref: FIRDatabaseReference?
    var name: String
    var gender: String
    var age: Int
    var backgroundColor: UIColor?
    var profileImage: UIImage?
    var hobbies: [String]

    init(name: String, gender: String, age: Int, backgroundColor: UIColor?, profileImage: UIImage?, hobbies: [String]) {
        self.uid = UUID().uuidString.hashValue
        self.name = name
        self.gender = gender
        self.age = age
        self.backgroundColor = backgroundColor
        self.profileImage = profileImage
        self.hobbies = hobbies
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref

        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! Int
        name = snapshotValue["name"] as! String
        gender = snapshotValue["gender"] as! String
        age = snapshotValue["age"] as! Int
        backgroundColor = (snapshotValue["backgroundColor"] as! [String: Float]).toUIColor()
        let imgData = Data(base64Encoded: snapshotValue["profileImage"] as! String, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        profileImage = UIImage(data: imgData)
        hobbies = snapshotValue["hobbies"] as! [String]
    }

    func toAnyObject() -> Any {
        let imageData: Data? = UIImagePNGRepresentation(profileImage!)
        let encodedImage: String = imageData!.base64EncodedString()
        return [
            "uid": uid,
            "name": name,
            "gender": gender,
            "age": age,
            "backgroundColor": backgroundColor?.toDictionary(),
            "profileImage":  encodedImage,
            "hobbies": hobbies,
        ]
    }
}
