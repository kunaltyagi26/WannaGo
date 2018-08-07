//
//  UpdateService.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 03/08/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class UpdateService {
    static var instance = UpdateService()
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == Auth.auth().currentUser?.uid {
                    DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                }
            }
        }
    }
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (driverSnapshot) in
            guard let driverSnapshot = driverSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for driver in driverSnapshot {
                if driver.key == Auth.auth().currentUser?.uid {
                    if driver.childSnapshot(forPath: "isUserPickupEnabled").value as? Bool == true {
                        DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                    }
                }
            }
        }
    }
}
