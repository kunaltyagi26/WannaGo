//
//  GradientView.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 18/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView() {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0.7, 1.0]
        self.layer.addSublayer(gradient)
    }

}
