//
//  CustomProfessionCell.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 09.03.2024.
//

import UIKit

class CustomProfessionCell: UICollectionViewCell {
    
    static let identifier = "CustomProfessionCell" 
    let professionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(professionLabel)
        professionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            professionLabel.topAnchor.constraint(equalTo: topAnchor),
            professionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            professionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            professionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }


    func configure(with profession: String) {
        professionLabel.text = profession
    }
}
