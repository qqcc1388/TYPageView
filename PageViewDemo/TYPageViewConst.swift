//
//  PageViewConst.swift
//  PageViewDemo
//
//  Created by Tiny on 2019/2/13.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

//MARK:- 屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let SCREENT_HEIGHT = UIScreen.main.bounds.size.height

//MARK:- 是否是IPX系列
let IS_IPhoneX_Series = (UIApplication.shared.statusBarFrame.height == 44)


func RGB(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat = 1.0) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func COLOR_RANDOM() -> UIColor{
    return RGB(CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)))
}
