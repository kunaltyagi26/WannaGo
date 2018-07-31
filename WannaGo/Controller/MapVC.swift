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

class MapVC: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sourceLocationDot: UIView!
    @IBOutlet weak var destLocationDot: UIView!
    @IBOutlet weak var requestRideBtn: UIButton!
    @IBOutlet weak var hamburgerBtn: UIButton!
    
    var isExpanded = true
    var revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122, zoom: 6.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
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
    
}

extension MapVC: GMSMapViewDelegate {
    
}

