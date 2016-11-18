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
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var hobbies: UITextField!

    // MARK: VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
