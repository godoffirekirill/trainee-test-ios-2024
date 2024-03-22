//
//  NothingFoundImageView.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 22.03.2024.
//

import UIKit

class NothingFoundImageView: UIView {
    
    @IBOutlet weak var nothingImageView: UIImageView!
    
    static func instanceFromNib() -> NothingFoundImageView {
        return UINib(nibName: "NothingFoundImageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NothingFoundImageView
    }
    func configure(imageName: String) {
        nothingImageView.image = UIImage(named: imageName)
    }
}

