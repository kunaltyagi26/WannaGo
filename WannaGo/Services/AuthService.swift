//
//  AuthService.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 25/06/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance =  AuthService()
    
    func registerUser(_ email: String, _ password: String, isDriver: Bool, completion: @escaping (_ status: Bool, _ error: Error?)-> ()) {
        Auth.auth().createUser(withEmail: email, password: email) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            else {
                guard let user = user else { return }
                print("User is:", user.user.uid)
                var userData: [String: Any]
                
                if isDriver == false {
                    userData = ["email": user.user.email, "isDriver": false] as [String: Any]
                }
                else {
                    userData = ["email": user.user.email, "isDriver": true, "isUserPickupEnabled": false, "driverIsOnTrip": false] as [String: Any]
                }
                
                DataService.instance.createUser(user.user.uid, userData, isDriver)
                
                completion(true, nil)
            }
        }
    }
    
    func loginUser(_ email: String, _ password: String, completion: @escaping (_ status: Bool, _ error: Error?)-> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Username:", email)
                print("Password:", password)
                print("User is:", user)
                completion(false, error)
                return
            }
            else {
                completion(true, nil)
            }
        }
    }
}
