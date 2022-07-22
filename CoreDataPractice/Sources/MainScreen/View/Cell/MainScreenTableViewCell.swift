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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.pinToSides(to: contentView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with text: String) {
        contentView.addSubview(label)
        accessoryType = .disclosureIndicator
        label.text = text
    }
}
