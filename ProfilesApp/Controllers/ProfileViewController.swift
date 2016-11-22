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
    @IBOutlet weak var containerStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var containerStackBottomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var hobbies: UITextField!
    @IBOutlet weak var editBackgroundColorButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var editBackgroundColorButton: UIButton! {
        didSet {
            setBorders(for: editBackgroundColorButton)
            editBackgroundColorButton.layer.cornerRadius = 0.5 * UISettings.menuButtonDiameter
        }
    }
    @IBOutlet weak var editProfileImageButton: UIButton! {
        didSet { setBorders(for: editProfileImageButton) }
    }
    @IBOutlet weak var dismissButton: UIButton! {
        didSet { setBorders(for: dismissButton) }
    }
    @IBOutlet weak var addProfileButton: UIButton! {
        didSet {
            setBorders(for: addProfileButton)
            if mode == .Edit { addProfileButton.setTitle("Submit Changes", for: .normal) }
        }
    }
    let dbRef = FIRDatabase.database().reference(withPath: "profiles")

    var mode: ProfileViewMode!
    var profile: Profile?

    var preferredImageWidth: CGFloat?
    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

    var colorPicker = ColorPickerController()
    var imagePicker = ImagePickerController()
    var genderPicker = UIPickerView()

    // MARK: VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickers()
        setDisabledFields()
        setButtons()
        setProfileImageWidth()
        setValuesOfTextFieldsProfileImageAndBackground()
        setContainerHeight()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        unsetNotifications()
    }

    // MARK: Init helper methods
    private func setNotifications(){
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    private func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    private func setProfileImageWidth(){
        if let width = preferredImageWidth {
            profileImageWidth.constant = width
        } else {
            profileImageWidth.constant = self.view.frame.width
        }
    }
    private func setPickers(){
        imagePicker.delegate = self

        genderPicker.delegate = self
        gender.inputView = genderPicker

        colorPicker.delegate = self
    }
    private func setValuesOfTextFieldsProfileImageAndBackground(){
        if let profile = self.profile {
            profileImage.image = profile.profileImage
            name.text = profile.name
            age.text = String(profile.age)
            gender.text = profile.gender.description
            hobbies.text = profile.hobbies.joined(separator: ", ")
            editBackgroundColorButton.backgroundColor = profile.backgroundColor
            matchEditBackgroundColorButtonTitleColor(to: profile.backgroundColor!)
        }
    }
    private func setContainerHeight() {
        if let overlayHeight = animationExpandedFrame?.height {
            containerStackViewHeight.constant = overlayHeight
        } else {
            containerStackViewHeight.constant = self.view.frame.height - 2.0 * UISettings.standardOffset
        }
    }
    private func setDisabledFields(){
        if mode == .Edit {
            name.isUserInteractionEnabled = false
            name.textColor = UISettings.gray
            age.isUserInteractionEnabled = false
            age.textColor = UISettings.gray
            gender.isUserInteractionEnabled = false
            gender.textColor = UISettings.gray
        }
    }
    private func setButtons(){
        if mode == .Edit {
            editProfileImageButton.isHidden = true
            editBackgroundColorButtonWidth.constant = UISettings.menuButtonDiameter
        } else if mode == .Add {
            editBackgroundColorButton.isHidden = true
        }
    }

    // MARK: Button handling methods
    @IBAction func editBackgroundColor(_ sender: UIButton) {
        colorPicker.animationExpandedFrame = view.convert(profileImage.bounds, from: profileImage)
        colorPicker.animationShrinkedFrame = view.convert(editBackgroundColorButton.bounds, from: editBackgroundColorButton)

        colorPicker.modalPresentationStyle = .custom
        colorPicker.transitioningDelegate = colorPicker

        self.present(colorPicker, animated: true, completion: nil)
    }
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
        let hobbies: [String] = self.hobbies.text!.characters.split(separator: ",").map(String.init).map{ $0.trimmingCharacters(in: .whitespaces) }

        if mode == .Add {
            let backgroundColor = (gender == .Female ? UISettings.green : UISettings.blue)
            let newProfile = Profile(name: name, gender: gender, age: age, backgroundColor: backgroundColor, profileImage: profileImage.image, hobbies: hobbies)

            let newProfileRef = dbRef.child(String(newProfile.uid))
            newProfileRef.setValue(newProfile.toAnyObject())

        } else if mode == .Edit {
            let backgroundColor = editBackgroundColorButton.backgroundColor!
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
        let bottomStackViewFrame = view.convert(containerStackBottomView.bounds, from: containerStackBottomView)
        let difference = keyboardFrame.origin.y - bottomStackViewFrame.origin.y

        if  difference >= 0 {
            // Keyboard doesn't obscure last visible text view, no need to scroll
        } else {
            let margin: CGFloat = CGFloat(3.0) * UISettings.standardOffset
            let contentFrame = containerStackView.frame.size
            backgroundScroll.contentSize = CGSize(width: contentFrame.width,
                                                  height: contentFrame.height + keyboardFrame.height - margin)
            let bottomOffset = CGPoint(x: 0, y: backgroundScroll.contentSize.height - backgroundScroll.bounds.size.height)
            backgroundScroll.setContentOffset(bottomOffset, animated: true)
        }
    }
    private func highlightEmptyTextFields() -> Bool {
        var errors = 0

        func setRedBorder(_ textField: UITextField) {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = UISettings.cornerRadius
            textField.layer.borderWidth = UISettings.borderWidth
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
    private func setBorders(for button: UIButton){
        button.layer.cornerRadius = UISettings.cornerRadius
        button.layer.borderWidth = UISettings.borderWidth
        button.layer.borderColor = UISettings.gray.cgColor
    }
    fileprivate func matchEditBackgroundColorButtonTitleColor(to color: UIColor) {
        var hue = CGFloat(0), saturation = CGFloat(0), brightness = CGFloat(0), alpha = CGFloat(0)
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if saturation < CGFloat(0.5) && brightness > CGFloat(0.75) {
            editBackgroundColorButton.setTitleColor(UISettings.darkGray, for: .normal)
        } else {
            editBackgroundColorButton.setTitleColor(UISettings.white, for: .normal)
        }
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

// MARK: UIPickerViewDataSource and UIPickerViewDelegate methods
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

// MARK: ColorPickerDelegate methods
extension ProfileViewController: ColorPickerDelegate {
    func colorPickerTouched(sender: ColorPickerController, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        editBackgroundColorButton.backgroundColor = color
        profile?.backgroundColor = color
        matchEditBackgroundColorButtonTitleColor(to: color)
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
