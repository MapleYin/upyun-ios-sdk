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
        
        var params = UpLoadParams(bucket:"bucket", saveKey:"saveKey")
        params.contentLengthRange = SizeRange(min:1,max:12)
        params.date = Date()
        Upload(Data(), params: params)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

