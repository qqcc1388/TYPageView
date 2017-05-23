//
//  TYPageTitleView.swift
//  TYPageViewDemo1
//
//  Created by Tiny on 2017/5/18.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

import UIKit

protocol TYPageTitleViewDelegate : class {
    func pageView(pageView:TYPageTitleView,selectIndex:Int)
}

class TYPageTitleView: UIView {
    
    weak var delegate:TYPageTitleViewDelegate?
    
    fileprivate var style:TYPageStyle
    
    var titles:[String]
    var titleLabels:[UILabel] = [UILabel]()
    lazy var scrollView:UIScrollView = {
        let scroll:UIScrollView = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    lazy var lineView:UIView = {
        let line = UIView()
        line.backgroundColor = self.style.bottomLineColor
        line.frame.size.height = 2
        line.frame.origin.y = self.bounds.size.height - line.frame.size.height
        return line
    }()
    
    fileprivate var currentIndex:Int = 0

    
    
    init(frame:CGRect,titles:[String],style:TYPageStyle = TYPageStyle()) {
        
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TYPageTitleView{
    fileprivate func setupUI(){
        
        //设置scrollView
        addSubview(scrollView)
        //初始化lineView
        scrollView.addSubview(lineView)
        //初始化title
        setupLabels()
    }
    
    // MARK: 初始化Item
    private func setupLabels(){
        var x:CGFloat = 0
        let y:CGFloat = 0
        var textWidth:CGFloat = 0
        var labelWidth:CGFloat = 0
        let height:CGFloat = self.style.labelHeight
        let margin:CGFloat = self.style.labelMargin
        let normalWidth:CGFloat = 60
        var preLabel:UILabel = UILabel()
        for (i,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.labelFont)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.isUserInteractionEnabled = true
            titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemClick(_:))))
            //设置frame
            textWidth = widthForContent(titleLabel)
            if style.labelLayout == .divide{
                labelWidth = bounds.size.width/CGFloat(titles.count)
            }else if style.labelLayout == .center{
                labelWidth = normalWidth
            }else{
                labelWidth = textWidth
            }
            
            if i == 0{
                if style.labelLayout == .scroll {
                    x = margin*0.5
  
                }else if style.labelLayout == .divide{
                    x = 0
                }
                else{  //设置居中情况下x
                    x = (bounds.size.width - textWidth*CGFloat(titles.count))/CGFloat(2)
                }

                lineView.frame.origin.x = x
                lineView.frame.size.width = style.bottomAlginLabel ? labelWidth : textWidth
                titleLabel.textColor = style.selectColor

            }else{
                if style.labelLayout == .scroll {
                    x = preLabel.frame.maxX + margin
                }else {
                    x = preLabel.frame.maxX
                }
            }
            titleLabel.frame = CGRect(x: x, y: y, width: labelWidth, height: height)

            //添加到视图中
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            preLabel = titleLabel
        }
        
        //设置scrollView的ContentSize
        scrollView.contentSize = CGSize(width: preLabel.frame.maxX+margin*0.5, height: 0)
        scrollView.bringSubview(toFront: lineView)
    }
    
    fileprivate func widthForContent(_ label:UILabel) -> CGFloat{
       return ((label.text! as NSString).boundingRect(with: CGSize(width : CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:label.font], context: nil)).width
    }

}

extension TYPageTitleView{
    
    private func ajustViewPostion(_ selectLabel:UILabel){
        let preLabel = titleLabels[currentIndex]
        currentIndex = selectLabel.tag
        
        preLabel.textColor = style.normalColor
        selectLabel.textColor = style.selectColor
        
        //设置lineView的位置
        //计算textWidth
        UIView .animate(withDuration: 0.25) {
            if self.style.bottomAlginLabel{
                self.lineView.frame.origin.x = selectLabel.frame.origin.x
            }else{
                //使用center.x会有偏差，采用frame.x
                self.lineView.frame.origin.x = (selectLabel.frame.size.width - self.widthForContent(selectLabel))/CGFloat(2) + selectLabel.frame.minX
            }
            self.lineView.frame.size.width = self.style.bottomAlginLabel ? selectLabel.frame.size.width : self.widthForContent(selectLabel)
        }
        
        if style.labelLayout == .scroll {
            
            if scrollView.contentSize.width <= bounds.size.width { 
                return
            }
            //中间offset
            var offsetX = selectLabel.center.x - bounds.size.width*0.5
            //最大offset
            let maxOffset = scrollView.contentSize.width - bounds.width
            //最小offset
            if offsetX <= 0{
                offsetX = 0
            }else if offsetX >= maxOffset{
                offsetX = maxOffset
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
    @objc fileprivate func itemClick(_ tap:UITapGestureRecognizer){
        //获取目标item
        let selectLabel = tap.view as! UILabel
        //调整位置
        ajustViewPostion(selectLabel)
        //通知外部选中状态
        delegate?.pageView(pageView: self, selectIndex: currentIndex)
    }
    
    // MARK: 更新label 更新lineView
    func pageViewScroll(nextIndex:Int,progress:CGFloat){
        
        let currentLabel = titleLabels[currentIndex]
        let nextLabel = titleLabels[nextIndex]
        
        //设置字体颜色渐变
        if style.isShowLabelScale {
            let selectRGB = getGRBValue(style.selectColor)
            let normalRGB = getGRBValue(style.normalColor)
            let deltaRGB = (selectRGB.0 - normalRGB.0, selectRGB.1 - normalRGB.1, selectRGB.2 - normalRGB.2)
            currentLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
            nextLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        }
        
        //设置lineView宽度的渐变
        if style.isShowBottomLine {
            //1.位置的变化
            var deltaX:CGFloat = 0
            if style.bottomAlginLabel {
               deltaX = nextLabel.center.x - currentLabel.center.x
            }else{
                deltaX = nextLabel.center.x - currentLabel.center.x
            }
            lineView.center.x = currentLabel.center.x + deltaX*progress
            //2.宽度的变化
            var deltaW:CGFloat = 0
            if style.bottomAlginLabel {
                deltaW = nextLabel.bounds.width - currentLabel.bounds.width
            }else{
                deltaW = widthForContent(nextLabel) - widthForContent(currentLabel)
            }
            lineView.frame.size.width = (style.bottomAlginLabel ? currentLabel.frame.size.width : widthForContent(currentLabel)) + deltaW*progress
            //设置字体大小的渐变
        }

    }
    
    func pageViewScrollEnd(pageIndex:Int){
        
        //拿到选中的label
        let selectLabel = titleLabels[pageIndex]
        ajustViewPostion(selectLabel)
        
    }
    
    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
