//
//  ViewController.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 17/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import GoogleMaps
import RevealingSplashView
import Firebase

class MapVC: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sourceLocationDot: UIView!
    @IBOutlet weak var destLocationDot: UIView!
    @IBOutlet weak var requestRideBtn: UIButton!
    @IBOutlet weak var hamburgerBtn: UIButton!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var markers: [DriverAnnotation]?

    var zoomLevel: Float = 15.0
    
    var isExpanded = true
    var revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        mapView.delegate = self

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.869405, longitude: 151.199, zoom: zoomLevel)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        /*marker.position = camera.target
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.icon = UIImage(named: "driverAnnotation")
        marker.appearAnimation = .pop*/
        //marker.map = mapView
        
        loadDriverAnnotation()
        
        userImageView.setupCircularView()
        sourceLocationDot.setupCircularView()
        destLocationDot.setupCircularView()
        
        userImageView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        sourceLocationDot.borderColor = #colorLiteral(red: 0.05490196078, green: 0.462745098, blue: 0.2352941176, alpha: 1)
        destLocationDot.borderColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        
        locationView.setupShadowView()
        requestRideBtn.setupShadowView()
        
        hamburgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        hamburgerBtn.addTarget(self, action: #selector(hamburgerBtnPressed), for: .touchUpInside)
        
        revealViewController().frontViewShadowRadius = 10
        revealViewController().frontViewShadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc func hamburgerBtnPressed() {
        
        if isExpanded == false {
            self.view.alpha = 1
        }
        else {
            self.view.alpha = 0.7
        }
        isExpanded = !isExpanded
    }

    @IBAction func requestBtnTouchedDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.requestRideBtn.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    @IBAction func requestBtnTouchedUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.requestRideBtn.transform = CGAffineTransform.identity
        }) { (completed) in
            if completed {
                self.requestRideBtn.animateButton(shouldLoad: true, withMessage: nil)
            }
        }
    }
    
    @IBAction func centreMapBtnPressed(_ sender: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.distanceFilter = 0
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func loadDriverAnnotation() {
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (driverSnapshot) in
            guard let driverSnapshot = driverSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for driver in driverSnapshot {
                if driver.hasChild("coordinate") {
                    if driver.childSnapshot(forPath: "isUserPickupEnabled").value as? Bool == true {
                        guard let driverDict = driver.value as? Dictionary<String, AnyObject> else { return }
                        let coordinateArray = driverDict["coordinate"] as! NSArray
                        let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                        
                        print(driverCoordinate)
                        
                        let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey: driver.key)
                        annotation.position = driverCoordinate
                        annotation.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        annotation.icon = UIImage(named: "driverAnnotation")
                        annotation.appearAnimation = .pop
                        annotation.map = self.mapView
                        self.markers?.append(annotation)
                        
                        var isDriverVisible: Bool {
                            var status: Bool = false
                            for marker in self.markers! {
                                if marker.key == annotation.key {
                                    marker.update(annotationPosition: marker, withCoordinate: driverCoordinate)
                                    status = true
                                    return status
                                }
                                else {
                                    status = false
                                }
                            }
                            return status
                        }
                    }
                }
            }
        }
    }
    
}

extension MapVC: GMSMapViewDelegate {
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        UpdateService.instance.updateUserLocation(withCoordinate: location.coordinate)
        UpdateService.instance.updateDriverLocation(withCoordinate: location.coordinate)
        
        //marker.position = location.coordinate
        //marker.map = mapView
        
        currentLocation = location
        //print("Set to:", currentLocation)
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted:
                print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

