//
//  TYPageStyle.swift
//  TYPageViewDemo1
//
//  Created by Tiny on 2017/5/18.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

import UIKit

enum LabelLayout {
    case scroll   //滚动
    case divide   //平分
    case center   //居中
}

class TYPageStyle {
    
    var labelHeight:CGFloat = 44            //标签高度
    var labelMargin:CGFloat = 20            //标签间隔
    var labelFont:CGFloat = 15              //标签字体大小
    var labelLayout:LabelLayout = .scroll   //默认可以滚动
    var selectColor:UIColor = UIColor(r: 255, g: 0, b: 0)  //字体颜色必须为rgb格式
    var normalColor:UIColor = UIColor(r: 0, g: 0, b: 0)    //字体颜色必须为rgb格式
    var isShowLabelScale:Bool = true        //是否显示文字动画

    var isShowBottomLine:Bool = true        //是否显示底部的线
    var bottomLineColor:UIColor = .red
    var bottomAlginLabel:Bool = true        //bottomline跟随文字标签宽度  默认跟随label的宽度 false跟随labelText的宽度
}
