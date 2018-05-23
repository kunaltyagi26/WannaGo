//
//  UIButtonExt.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func animateButton(shouldLoad: Bool, withMessage message: String?) {
        let originalSize: CGRect? = self.frame
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.alpha = 0
        spinner.color = UIColor.red
        spinner.hidesWhenStopped = true
        
        if shouldLoad {
            self.isUserInteractionEnabled = false
            self.addSubview(spinner)
            self.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
                shrinkAnim.fromValue = self.frame.width
                shrinkAnim.toValue = self.frame.height
                shrinkAnim.duration = 0.2
                shrinkAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                shrinkAnim.fillMode = kCAFillModeForwards
                shrinkAnim.isRemovedOnCompletion = false
                self.layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
            }) { (completed) in
                if completed {
                    spinner.frame = self.frame
                    self.layer.cornerRadius = self.frame.height / 2
                    spinner.startAnimating()
                    spinner.center = CGPoint(x: self.frame.height / 2 + 1, y: self.frame.height / 2 + 1)
                    UIView.animate(withDuration: 0.2, animations: {
                        spinner.alpha = 1
                    })
                    self.isUserInteractionEnabled = true
                }
            }
        }
        else {
            spinner.removeFromSuperview()
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = 10
                self.frame = originalSize!
                self.setTitle(message, for: .normal)
            })
            self.isUserInteractionEnabled = true
        }
    }
    
}
