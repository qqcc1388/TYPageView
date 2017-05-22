//
//  TYContentController.swift
//  TYPageViewDemo1
//
//  Created by Tiny on 2017/5/18.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

import UIKit

class TYContentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(displayP3Red: CGFloat(arc4random_uniform(255))/255, green: CGFloat(arc4random_uniform(255))/255, blue: CGFloat(arc4random_uniform(255))/255, alpha: 1)
        
    }


}
