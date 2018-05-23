//
//  LoginVC.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loginTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let font = UIFont.init(name: "Avenir Next", size: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        
        loginBtn.setupShadowView()
        segmentedControl.setupShadowView()
        
        loginTxt.autocorrectionType = UITextAutocorrectionType.no
        
        //loginTxt.bindToKeyboard(offset: 40)
        //passwordTxt.bindToKeyboard(offset: 40)
        //loginBtn.bindToKeyboard(offset: 40)
        self.view.bindToKeyboard(offset: 40)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender: )))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.loginBtn.transform = CGAffineTransform.identity
        }) { (completed) in
            if completed {
                self.loginBtn.animateButton(shouldLoad: true, withMessage: nil)
            }
        }
    }
    
    @IBAction func loginBtnDownPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.loginBtn.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
}
