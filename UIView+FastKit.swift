//
//  UIView+FastKit.swift
//  PageViewDemo
//
//  Created by Tiny on 2019/2/13.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

//MARK:- UIView 常用frame方法分类
extension UIView{
    
    var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame;
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame;
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame;
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame;
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
}
