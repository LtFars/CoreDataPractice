//
//  UIViewController+Extension.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(on view: UIView? = nil) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        let onView: UIView = view ?? self.view
        onView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func setupTopButtons(action: Selector) {
        let backButton = UIBarButtonItem(
            title: String(),
            style: .plain,
            target: self,
            action: #selector(popAction)
        )
        
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: action
        )
        
        let customButton = UIButton()
        customButton.setTitle("Edit", for: .normal)
        customButton.setTitleColor(.link, for: .normal)
        customButton.setTitleColor(.black, for: .highlighted)
        customButton.layer.cornerRadius = 8
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor.link.cgColor
        editButton.customView = customButton
        customButton.titleLabel?.pinToSides(to: customButton)
        customButton.addTarget(self, action: action, for: .touchUpInside)
        
        backButton.image = UIImage(systemName: "xmark")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
