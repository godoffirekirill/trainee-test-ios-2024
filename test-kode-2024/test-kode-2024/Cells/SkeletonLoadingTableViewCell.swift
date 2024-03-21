//
//  SkeletonLoadingTableViewCell.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 21.03.2024.
//

import UIKit

class SkeletonLoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avararLoadingView: UIView!
    
    @IBOutlet weak var nameLoadingView: UIView!
    
    @IBOutlet weak var positionLoadingView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avararLoadingView.layer.cornerRadius = avararLoadingView.bounds.width / 2
        avararLoadingView.layer.masksToBounds = true
        
    }
    
}
