//
//  RoundedTextField.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 23/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    private var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = 10
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
