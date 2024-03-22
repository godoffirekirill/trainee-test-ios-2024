//
//  LoadErrorView.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 22.03.2024.
//

import UIKit

class LoadErrorView: UIView {

    @IBOutlet weak var textView: UITextView!
    static func instanceFromNib() -> LoadErrorView {
        return UINib(nibName: "LoadErrorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadErrorView
    }
    
    func configure(text: String) {
        //   let labelText = "I can't update the data.\nCheck your internet connection."
        textView.text = text
       }}
