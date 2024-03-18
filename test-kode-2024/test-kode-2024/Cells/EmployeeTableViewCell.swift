//
//  EmployeeTableViewCell.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 14.03.2024.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Customize appearance of avatar image view (e.g., make it circular)
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    
}

