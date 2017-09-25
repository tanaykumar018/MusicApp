//
//  UIViewController+HideKeyBrd.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboardd))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboardd() {
        view.endEditing(true)
    }
}
