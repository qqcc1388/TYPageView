//
//  ViewController.swift
//  PageViewDemo
//
//  Created by Tiny on 2019/2/13.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pageView = TYPageView(frame: view.bounds,
                                titles: ["推荐","热点推荐","视频","深圳推荐","推荐","热点","视频","深圳推荐","推荐","热点推荐","视频","深圳"],
                                childControllers: [TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController(),TestViewController()],
                                parentController: self)
        pageView.backgroundColor = UIColor.cyan
        view.addSubview(pageView)
    }
}

