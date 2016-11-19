//
//  ProfileViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundScroll: UIScrollView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var hobbies: UITextField!
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

    // MARK: VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        profileImageWidth.constant = view.frame.width
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: Button handling methods
    @IBAction func dismissProfile() {
        // TODO: Implement!
        print("dismissProfile")
    }
    @IBAction func addProfile() {
        // TODO: Implement!
        print("addProfile")
    }

    // MARK: Keyboard handling methods
    @objc private func keyboardWillShow(notification: NSNotification){
        let infoKey: AnyObject  = notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let keyboardFrame = view.convert(infoKey.cgRectValue!, from: nil)

        offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: keyboardFrame)
    }
    @objc private func keyboardWillHide(){
        backgroundScroll.contentOffset = CGPoint(x: 0, y: 0)
    }

    // MARK: Helper methods
    private func offsetBackgroundScrollViewToKeepTextFieldsVisible(keyboardFrame: CGRect){
        let stackViewFrame = view.convert(containerStackView.bounds, from: containerStackView)
        let margin: CGFloat = 12.0

        let difference = (keyboardFrame.origin.y - margin) - (stackViewFrame.origin.y + stackViewFrame.height)
        if  difference >= 0 {
            // Keyboard doesn't obscure last visible text view, no need to scroll
        } else {
            backgroundScroll.contentOffset = CGPoint(x: 0, y: -difference)
        }
    }
}
