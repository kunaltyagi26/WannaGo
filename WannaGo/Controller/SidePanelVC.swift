//
//  SidePanelVC.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import Firebase

class SidePanelVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pickupMode: UISwitch!
    @IBOutlet weak var pickupModeLabel: UILabel!
    
    let currentId = Auth.auth().currentUser?.uid
    let appDelegate = AppDelegate.getAppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userImage.setupCircularView()
        userImage.alpha = 0
        userId.alpha = 0
        userType.alpha = 0
        pickupMode.alpha = 0
        pickupModeLabel.alpha = 0
        
        pickupMode.isOn = false
        
        if Auth.auth().currentUser == nil {
            userId.text = ""
            userType.text = ""
            userImage.alpha = 0
            pickupMode.alpha = 0
            pickupModeLabel.alpha = 0
            loginBtn.setTitle("Sign Up/Login", for: .normal)
            
        }
        else {
            guard let email = Auth.auth().currentUser?.email else { return }
            userId.alpha = 1
            userId.text = email
            userImage.alpha = 1
            loginBtn.setTitle("Logout", for: .normal)
            
            observeDriverAndPassenger()
        }
        
    }
    
    func observeDriverAndPassenger() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == Auth.auth().currentUser?.uid {
                    self.userType.alpha = 1
                    self.userType.text = "Passenger"
                }
            }
        }
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == Auth.auth().currentUser?.uid {
                    self.userType.alpha = 1
                    self.userType.text = "Driver"
                    
                    let switchStatus = user.childSnapshot(forPath: "isUserPickupEnabled").value as! Bool
                    self.pickupMode.isOn = switchStatus
                    self.pickupMode.alpha = 1
                    self.pickupModeLabel.alpha = 1
                }
            }
        }
    }
    
    @IBAction func LoginBtnPressed(_ sender: UIButton) {
        if Auth.auth().currentUser == nil {
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC") as? LoginVC else { return }
            present(loginVC, animated: true, completion: nil)
        }
        else {
            do {
                try Auth.auth().signOut()
                self.userId.text = ""
                self.userType.text = ""
                self.userImage.alpha = 0
                self.loginBtn.setTitle("Sign Up/Login", for: .normal)
                self.pickupMode.alpha = 0
                self.pickupModeLabel.alpha = 0
            }
            catch(let error) {
                print(error)
            }
        }
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            pickupModeLabel.text = "Pickup Mode Enabled"
            DataService.instance.REF_DRIVERS.child(currentId!).updateChildValues(["isUserPickupEnabled": true])
        }
        else {
            pickupModeLabel.text = "Pickup Mode Disabled"
            DataService.instance.REF_DRIVERS.child(currentId!).updateChildValues(["isUserPickupEnabled": false])
        }
    }
}
