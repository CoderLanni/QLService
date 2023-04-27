//
//  ViewController.swift
//  QLService
//
//  Created by Simon on 04/27/2023.
//  Copyright (c) 2023 Simon. All rights reserved.
//

import UIKit
import QLService
 
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        QLService.default.paidMethod(project: .yoni)
        QLService.default.getCurrentVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

