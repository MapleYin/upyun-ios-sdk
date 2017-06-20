//
//  ViewController.swift
//  upyun-sdk
//
//  Created by mapleiny on 06/20/2017.
//  Copyright (c) 2017 mapleiny. All rights reserved.
//

import UIKit
import upyun_sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let en = AuthorisedString(operatorString: "operator123", password: "password123", uri: "/upyun-temp/demo.jpg",method: .put)
        
        print("AuthorisedString:\(en)");
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

