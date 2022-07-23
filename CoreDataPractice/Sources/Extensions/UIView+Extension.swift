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
    
    func pinSeparator(
        to view: UIView,
        xMargin: CGFloat = 0,
        yMargin: CGFloat = 0
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: yMargin),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xMargin),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xMargin),
            self.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    static func separator(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
}
