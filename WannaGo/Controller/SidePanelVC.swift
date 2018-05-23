//
//  SidePanelVC.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 19/05/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class SidePanelVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.setupCircularView()
        userImage.alpha = 0
        userId.alpha = 0
        userType.alpha = 0
    }
    
}
