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
            editProfileImageButton.layer.cornerRadius = Settings.cornerRadius
            editProfileImageButton.layer.borderWidth = Settings.borderWidth
            editProfileImageButton.layer.borderColor = Settings.gray.cgColor
        }
    }
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = Settings.cornerRadius
            dismissButton.layer.borderWidth = Settings.borderWidth
            dismissButton.layer.borderColor = Settings.gray.cgColor
        }
    }
    @IBOutlet weak var addProfileButton: UIButton! {
        didSet {
            addProfileButton.layer.cornerRadius = Settings.cornerRadius
            addProfileButton.layer.borderWidth = Settings.borderWidth
            addProfileButton.layer.borderColor = Settings.gray.cgColor
            if mode == .Edit {
                addProfileButton.setTitle("Submit Changes", for: .normal)
            }
        }
    }
    let dbRef = FIRDatabase.database().reference(withPath: "profiles")

    var mode: ProfileViewMode!
    var profile: Profile?

    var preferredImageWidth: CGFloat?
    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

    var imagePicker = ImagePickerController()
    var genderPicker = UIPickerView()

    // MARK: VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImage()
        setImagePicker()
        setGenderPicker()
        setTextFieldsValuesAndProfileImage()
        setDisabledFieldsAndButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        unsetNotifications()
    }

    // MARK: Init helper methods
    func setNotifications(){
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    func setProfileImage(){
        if let width = preferredImageWidth {
            profileImageWidth.constant = width
        } else {
            profileImageWidth.constant = self.view.frame.width
        }
    }
    func setImagePicker(){
        imagePicker.delegate = self
    }
    func setGenderPicker(){
        genderPicker.delegate = self
        gender.inputView = genderPicker
    }
    func setTextFieldsValuesAndProfileImage() {
        if let profile = self.profile {
            profileImage.image = profile.profileImage
            name.text = profile.name
            age.text = String(profile.age)
            gender.text = profile.gender.description
            hobbies.text = profile.hobbies.joined(separator: ", ")
        }
    }
    func setDisabledFieldsAndButtons(){
        if mode == .Edit {
            name.isUserInteractionEnabled = false
            name.textColor = Settings.gray
            age.isUserInteractionEnabled = false
            age.textColor = Settings.gray
            gender.isUserInteractionEnabled = false
            gender.textColor = Settings.gray
            editProfileImageButton.isHidden = true
        }
    }

    // MARK: Button handling methods
    @IBAction func editProfileImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){

            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.allowsEditing = true

            imagePicker.animationExpandedFrame = animationExpandedFrame
            imagePicker.animationShrinkedFrame = animationShrinkedFrame

            imagePicker.modalPresentationStyle = .custom
            imagePicker.transitioningDelegate = imagePicker

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func dismissProfile() {
        self.performSegue(withIdentifier: "dismissMe", sender: self)
    }
    @IBAction func addOrEditProfile() {
        let textFieldsAreNotEmpty = !highlightEmptyTextFields()
        guard textFieldsAreNotEmpty else { return }

        let name = self.name.text!.capitalized
        let gender = Gender(rawValue: self.gender.text!)!
        let age = Int(self.age.text!)!
        let backgroundColor = (gender == .Female ? Settings.green : Settings.blue)
        let hobbies: [String] = self.hobbies.text!.characters.split(separator: ",").map(String.init).map{ $0.trimmingCharacters(in: .whitespaces) }

        if mode == .Add {
            let newProfile = Profile(name: name, gender: gender, age: age, backgroundColor: backgroundColor, profileImage: profileImage.image, hobbies: hobbies)

            let newProfileRef = dbRef.child(String(newProfile.uid))
            newProfileRef.setValue(newProfile.toAnyObject())

        } else if mode == .Edit {
            profile?.ref?.updateChildValues(["hobbies" : hobbies,
                                             "backgroundColor" : backgroundColor.toDictionary()])
        }
        self.performSegue(withIdentifier: "dismissMe", sender: self)
    }

    // MARK: Keyboard handling methods
    @objc private func keyboardWillShow(notification: NSNotification){
        let infoKey: AnyObject  = notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let keyboardFrame = view.convert(infoKey.cgRectValue!, from: nil)

        offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: keyboardFrame)
    }
    @objc private func keyboardWillHide(){
        backgroundScroll.contentSize = containerStackView.frame.size
        backgroundScroll.contentOffset = CGPoint(x: 0, y: 0)
    }

    // MARK: Helper methods
    private func offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: CGRect){
        let stackViewFrame = view.convert(containerStackView.bounds, from: containerStackView)
        let margin: CGFloat = Settings.standardOffset

        let difference = (keyboardFrame.origin.y - margin) - (stackViewFrame.origin.y + stackViewFrame.height)
        if  difference >= 0 {
            // Keyboard doesn't obscure last visible text view, no need to scroll
        } else {
            let contentFrame = containerStackView.frame.size
            backgroundScroll.contentSize = CGSize(width: contentFrame.width,
                                                  height: contentFrame.height + keyboardFrame.height)
            backgroundScroll.contentOffset = CGPoint(x: 0, y: -difference)
        }
    }
    private func highlightEmptyTextFields() -> Bool {
        var errors = 0

        func setRedBorder(_ textField: UITextField) {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = Settings.cornerRadius
            textField.layer.borderWidth = Settings.borderWidth
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

// MARK: UIImagePickerControllerDelegate methods
extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Gender.allValues().count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let values = Gender.allValues()
        return values[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let values = Gender.allValues()
        gender.text = values[row]
    }
}

// MARK: UIViewControllerTransitioningDelegate methods
extension ProfileViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presented == self ?
            CustomPresentationController(presentedViewController: presented, presentingViewController: source, startingFrame: animationShrinkedFrame!)
            : nil
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presented == self ?
            CustomTransition(isPresenting: true, frameToResizeTo: animationExpandedFrame!)
            : nil
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissed == self ?
            CustomTransition(isPresenting: false, frameToResizeTo: animationShrinkedFrame!)
            : nil
    }
}
