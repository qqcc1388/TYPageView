//
//  ViewController.swift
//  TYPageViewDemo1
//
//  Created by Tiny on 2017/5/18.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        let titles = ["推荐","热点","健身","海贼王","大闹天宫","推荐","热点","健身","海贼王","大闹天宫"]
        var childsVc:[UIViewController] = [UIViewController]()
        for _ in 0..<titles.count {
            let contentVc = TYContentController()
            childsVc.append(contentVc)
        }
        let pageView = TYPageView(frame: view.bounds, titles: titles, childControllers: childsVc, parentController: self)
        view.addSubview(pageView)
    }

}

