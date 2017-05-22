//
//  TYPageView.swift
//  TYPageViewDemo1
//
//  Created by Tiny on 2017/5/18.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

import UIKit
import Foundation

class TYPageView: UIView {

    fileprivate var titles:[String]
    fileprivate var controllers:[UIViewController]
    fileprivate var parentVc:UIViewController
    fileprivate var style:TYPageStyle
    
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    fileprivate lazy var titleView: TYPageTitleView = {[unowned self] in
        let titleView:TYPageTitleView = TYPageTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.style.labelHeight), titles: self.titles, style: self.style)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height - self.style.labelHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: self.style.labelHeight, width: self.bounds.size.width, height: self.bounds.size.height - self.style.labelHeight), collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collection.scrollsToTop = false
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        return collection
        
    }()
    
    init(frame:CGRect,titles:[String],childControllers:[UIViewController],parentController:UIViewController,style:TYPageStyle = TYPageStyle()) {
        
        //初始化参数
        self.titles = titles
        self.controllers = childControllers
        self.style = style
        self.parentVc = parentController
        
        super.init(frame: frame)
        
        //UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TYPageView {
    
    fileprivate func setupUI(){
        
        //设置titleView
        addSubview(titleView)

        //设置子控制器
        for vc  in controllers {
            parentVc.addChildViewController(vc)
        }
        //设置contentView
        addSubview(collectionView)
        
    }
}

extension TYPageView:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
  
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = controllers[indexPath.row]
        vc.view.frame = cell.contentView.bounds
        cell.contentView .addSubview(vc.view)
        
        return cell
    }
}

extension TYPageView:UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        isForbideScroll = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if startOffsetX == scrollView.contentOffset.x { return }
        if isForbideScroll { return}
        
        //scroll滚动的情况下，让item大小变化
        var progress:CGFloat = 0
        var nextIndex = 0
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        
        //判断是左移还是右移
        if startOffsetX > scrollView.contentOffset.x{    //右移动
            nextIndex = currentIndex - 1
            if nextIndex < 0 {
                nextIndex = 0
            }
            //计算progress
            progress = (startOffsetX - scrollView.contentOffset.x)/width
        }
        if startOffsetX < scrollView.contentOffset.x{    //左移
            
            nextIndex = currentIndex + 1
            if nextIndex > count - 1 {
                nextIndex = count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX)/width
        }
        titleView.pageViewScroll(nextIndex: nextIndex, progress: progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //拖动结束 计算index
        var index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        if index < 0{
            index = 0
        }
        if index > count - 1 {
            index = count - 1
        }
        //设置viewFrame
        currentIndex = index
        //让pageView滚动起来
        titleView.pageViewScrollEnd(pageIndex: index)
    }
}

extension TYPageView : TYPageTitleViewDelegate{
    
    func pageView(pageView: TYPageTitleView, selectIndex: Int) {
        isForbideScroll = true
        //设置view frame
         currentIndex = selectIndex
        //让collectionView滚动
        let indexPath = IndexPath(row: selectIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

    
}
