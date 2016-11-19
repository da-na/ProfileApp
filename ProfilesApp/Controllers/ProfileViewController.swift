//
//  ProfileViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundScroll: UIScrollView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var hobbies: UITextField!
    @IBOutlet weak var editProfileImageButton: UIButton! {
        didSet {
            editProfileImageButton.layer.cornerRadius = 5
            editProfileImageButton.layer.borderWidth = 1
            editProfileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = 5
            dismissButton.layer.borderWidth = 1
            dismissButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var addProfileButton: UIButton! {
        didSet {
            addProfileButton.layer.cornerRadius = 5
            addProfileButton.layer.borderWidth = 1
            addProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    let dbRef = FIRDatabase.database().reference(withPath: "profiles")
    var imagePicker = UIImagePickerController()

    // MARK: VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        profileImageWidth.constant = view.frame.width
        imagePicker.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Button handling methods
    @IBAction func editProfileImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func dismissProfile() {
        self.performSegue(withIdentifier: "dismissMe", sender: self)
    }
    @IBAction func addProfile() {
        let textFieldsAreNotEmpty = !highlightEmptyTextFields()
        guard textFieldsAreNotEmpty else { return }

        let name = self.name.text!.capitalized
        let gender = self.gender.text!
        let age = Int(self.age.text!)!
        let backgroundColor = (gender == "Female" ? UIColor.green : UIColor.blue)
        let hobbies: [String] = self.hobbies.text!.characters.split(separator: ",").map(String.init).map{ $0.trimmingCharacters(in: .whitespaces) }

        let newProfile = Profile(name: name, gender: gender, age: age, backgroundColor: backgroundColor, profileImage: profileImage.image, hobbies: hobbies)

        let newProfileRef = dbRef.child(String(newProfile.uid))
        newProfileRef.setValue(newProfile.toAnyObject())

        self.performSegue(withIdentifier: "dismissMe", sender: self)
    }

    // MARK: Keyboard handling methods
    @objc private func keyboardWillShow(notification: NSNotification){
        let infoKey: AnyObject  = notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let keyboardFrame = view.convert(infoKey.cgRectValue!, from: nil)
        let contentFrame = containerStackView.frame.size
        backgroundScroll.contentSize = CGSize(width: contentFrame.width,
                                              height: contentFrame.height + keyboardFrame.height)
        offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: keyboardFrame)
    }
    @objc private func keyboardWillHide(){
        backgroundScroll.contentOffset = CGPoint(x: 0, y: 0)
        backgroundScroll.contentSize = containerStackView.frame.size
    }

    // MARK: Helper methods
    private func offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: CGRect){
        let stackViewFrame = view.convert(containerStackView.bounds, from: containerStackView)
        let margin: CGFloat = 20.0

        let difference = (keyboardFrame.origin.y - margin) - (stackViewFrame.origin.y + stackViewFrame.height)
        if  difference >= 0 {
            // Keyboard doesn't obscure last visible text view, no need to scroll
        } else {
            backgroundScroll.contentOffset = CGPoint(x: 0, y: -difference)
        }
    }
    private func highlightEmptyTextFields() -> Bool {
        var errors = 0

        func setRedBorder(_ textField: UITextField) {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        }
        func validate(_ textField: UITextField, _ placeholder: String) {
            if textField.text == nil || textField.text == "" {
                textField.placeholder = placeholder
                setRedBorder(textField)
                errors += 1
            }
        }
        validate(name, "Please enter your NAME here...")
        validate(age, "Your AGE goes here...")
        validate(gender, "Select your GENDER here...")
        validate(hobbies, "Your HOBBIES here...")

        return errors > 0
    }
}

// MARK: UIImagePickerControllerDelegate methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
