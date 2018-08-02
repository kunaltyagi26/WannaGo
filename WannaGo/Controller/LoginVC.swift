//
//  LoginVC.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loginTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var errorMsg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTxt.delegate = self
        passwordTxt.delegate = self

        let font = UIFont.init(name: "Avenir Next", size: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        
        loginBtn.setupShadowView()
        segmentedControl.setupShadowView()
        
        loginTxt.autocorrectionType = UITextAutocorrectionType.no
        
        self.view.bindToKeyboard(offset: 40)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as? RegisterVC else { return }
        revealViewController().setFront(registerVC, animated: true)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if loginTxt.text != nil && passwordTxt.text != nil {
            UIView.animate(withDuration: 0.2, animations: {
                self.loginBtn.transform = CGAffineTransform.identity
            }) { (completed) in
                if completed {
                    self.loginBtn.animateButton(shouldLoad: true, withMessage: nil)
                }
            }
            
            self.view.endEditing(true)
            
            guard let email = loginTxt.text else { return }
            guard let password = passwordTxt.text else { return }
            
            AuthService.instance.loginUser(email, password, completion: { (status, error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    guard let errorCode = AuthErrorCode(rawValue: error!._code) else { return }
                    
                    switch errorCode {
                    case AuthErrorCode.invalidEmail:
                        self.errorMsg = "Email Invalid. Please try again."
                    case AuthErrorCode.wrongPassword:
                        self.errorMsg = "Whoops! That was the wrong password."
                    case AuthErrorCode.userDisabled:
                        self.errorMsg = "Account is disabled. Please ask admin to enable it."
                    default:
                        self.errorMsg = "An unexpected error occured. Please try again."
                    }
                    
                    let alertController = UIAlertController(title: self.errorMsg, message: error?.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func loginBtnDownPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.loginBtn.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    
}
