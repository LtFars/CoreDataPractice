//
//  UIView+Extension.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

extension UIView {
    func pinToSides(to view: UIView, gap: CGFloat = 16) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gap),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gap)
        ])
    }
}
