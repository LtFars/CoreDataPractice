//
//  MainScreenTableViewCell.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

final class MainScreenTableViewCell: UITableViewCell {
    
    static let identifier = "MainScreenTableViewCell"
    
    // MARK: - Elements
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "ddwfwefwef"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
        label.removeFromSuperview()
        label.text?.removeAll()
    }
    
    // MARK: - Configuration
    
    func configure(with text: String) {
        contentView.addSubview(label)
        accessoryType = .disclosureIndicator
        label.text = text
        
        label.pinToSides(to: contentView)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
