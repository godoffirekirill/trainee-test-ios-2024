//
//  CriticalErrorViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 22.03.2024.
//

import UIKit

class CriticalErrorViewController: UIViewController {

    @IBOutlet weak var CriticalErrorView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CriticalErrorView.image = UIImage(named: "critical-error")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                CriticalErrorView.addGestureRecognizer(tapGestureRecognizer)
                CriticalErrorView.isUserInteractionEnabled = true
    }
    

    @IBAction func imageTapped() {
           // Navigate to the first root controller
           navigationController?.popToRootViewController(animated: true)
       }
}
