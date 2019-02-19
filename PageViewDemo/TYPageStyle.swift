//
//  PageStyle.swift
//  PageViewDemo
//
//  Created by Tiny on 2019/2/13.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

/// 布局方式
enum LabelLayout {
    case scroll   //滚动
    case divide   //平分
    case center   //居中
}

/// 移动方向
enum MoveDirection {
    case left   //左移
    case right   //右移
}

/// 移动动画
enum MoveAnimation {
    case fastScroll   //快速移动  仿微博效果
    case scroll       //滚动  跟随
}

class TYPageStyle {
    
    var labelHeight:CGFloat = 44            //标签高度  
    var labelMargin:CGFloat = 20            //标签间隔
    var labelFont:CGFloat = 15              //标签字体大小
    var labelCenterWidth: CGFloat = 50      //居中模式下label的默认宽度
    
    var labelLayout:LabelLayout = .divide   //默认可以滚动
    var moveAnimation: MoveAnimation = .fastScroll  //底部线运动d动画
    
    var isShowBottomLine:Bool = true        //是否显示底部的线
    var isShowColorScale:Bool = true        //是否显示文字颜色动画
    var bottomAlginLabel:Bool = true        //bottomline跟随文字标签宽度  默认跟随label的宽度 false跟随labelText的宽度

    var selectColor:UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)  //字体颜色必须为rgb格式 默认红色
    var normalColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)    //字体颜色必须为rgb格式  默认黑色
    var bottomLineColor:UIColor = .red
}

