//
//  RegisterVC.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 25/06/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var email: RoundedTextField!
    @IBOutlet weak var password: RoundedTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var errorMsg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont.init(name: "Avenir Next", size: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        
        signUpBtn.setupShadowView()
        segmentedControl.setupShadowView()
        
        email.autocorrectionType = UITextAutocorrectionType.no

        self.view.bindToKeyboard(offset: 40)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if email.text != nil && password.text != nil {
            UIView.animate(withDuration: 0.2, animations: {
                self.signUpBtn.transform = CGAffineTransform.identity
            }) { (completed) in
                if completed {
                    self.signUpBtn.animateButton(shouldLoad: true, withMessage: nil)
                }
            }
            
            self.view.endEditing(true)
            
            guard let email = email.text else { return }
            guard let password = password.text else { return }
            
            var isDriver: Bool
             
            if segmentedControl.selectedSegmentIndex == 0 {
                isDriver = false
            }
            else {
                isDriver = true
            }
            
            AuthService.instance.registerUser(email, password, isDriver: isDriver, completion: { (status, error) in
                if error == nil {
                    guard let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as? MapVC else { return }
                    self.revealViewController().setFront(mapVC, animated: true)
                }
                else {
                    guard let errorCode = AuthErrorCode(rawValue: error!._code) else { return }
                    
                    switch errorCode {
                    case AuthErrorCode.invalidEmail:
                        self.errorMsg = "Email Invalid. Please try again."
                    case AuthErrorCode.emailAlreadyInUse:
                        self.errorMsg = "Email already in use. Please try with a different email."
                    case AuthErrorCode.operationNotAllowed:
                        self.errorMsg = "Account is disabled. Please ask admin to enable it."
                    case AuthErrorCode.weakPassword:
                        self.errorMsg = "Password is weak. Please try with another password."
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
    
    @IBAction func signUpDownPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.signUpBtn.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
}
