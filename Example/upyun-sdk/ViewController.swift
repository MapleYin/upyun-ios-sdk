//
//  ViewController.swift
//  upyun-sdk
//
//  Created by mapleiny on 06/20/2017.
//  Copyright (c) 2017 mapleiny. All rights reserved.
//

import UIKit
import upyun_sdk
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        self.view.backgroundColor = UIColor.white
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
        
        
    }
    
    func add(_ button:UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        
        
        present(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func uploadImage(_ imageData:Data) {
        Config.setGlobal(username: "maple", password: "maple1105")
        Config.global.schema = .HTTP
        
        let params = UpLoadParams(bucket:"maple-static", saveKey:"/test.png")
            
        do {
            let client = try Upload(imageData, params: params)
                client.progress { (progress) in
                    print(progress)
                }.resume()
        } catch {
            
        }

        
    }

}



extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImagePNGRepresentation(image)
            uploadImage(imageData!)
        }
        
        
    }
}


extension ViewController : UINavigationControllerDelegate {
    
}

