//
//  CollectionViewCell.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 09.03.2024.
//

import UIKit

class EmployeeCell: UICollectionViewCell {
    
    static let identifier = "EmployeeCell"

    // Add UI elements for employee information (e.g., avatar, name, profession)

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Customize the cell's UI elements and layout
        // Example: Add subviews, set constraints, etc.

        // Add the nameLabel to the cell's content view
        contentView.addSubview(nameLabel)

        // Configure constraints for the nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }


    func configure(with employee: Item) {
        print("Configuring cell with employee: \(employee)")
        nameLabel.text = "\(employee.firstName) \(employee.lastName)"
        // Add logic to set other UI elements based on the employee data
    }

}

