//
// UIViewExt.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderColor: CGColor? {
        get {
            return layer.borderColor
        }
        set {
            layer.borderColor = newValue
        }
    }
    
    /*var offset: CGFloat? {
        get {
            return setValues.offset
        }
        set {
            self.offset = newValue
        }
    }
    
    private struct setValues {
        static var offset: CGFloat?
    }*/
    
    func setupCircularView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor
    }

    func setupShadowView() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func bindToKeyboard(offset: CGFloat) {
        //self.offset = offset
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
    /*func setOffset(offset: CGFloat) {
        self.offset = offset
    }
    
    func getOffset()-> CGFloat {
        return offset
    }*/
}
