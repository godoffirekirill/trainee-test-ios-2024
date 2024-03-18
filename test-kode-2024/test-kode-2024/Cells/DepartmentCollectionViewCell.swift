//
//  PositionCollectionViewCell.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 17.03.2024.
//
//
import UIKit

class DepartmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var departmentLabel: UILabel!
 //   @IBOutlet weak var department: UILabel!
    override var isSelected: Bool {
            didSet {
                departmentLabel.textColor = isSelected ? .black : .gray
                departmentLabel.attributedText = isSelected ? NSAttributedString(string: departmentLabel.text ?? "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.purple]) : NSAttributedString(string: departmentLabel.text ?? "")
            }
        }
}
