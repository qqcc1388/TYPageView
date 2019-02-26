//
//  PageView.swift
//  PageViewDemo
//
//  Created by Tiny on 2019/2/13.
//  Copyright © 2019年 hxq. All rights reserved.
//

import UIKit

class TYPageView: UIView {

    private var titles = [String]()
    private var controllers = [UIViewController]()
    private weak var parentVc: UIViewController!
    private var style: TYPageStyle!
    
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    //pageTitleView
    private lazy var pageTitleView: TYPageTitleView = {
        let pageTitleView = TYPageTitleView(frame: CGRect(x: 0, y: IS_IPhoneX_Series ? 44 : 20, width: self.bounds.width, height: self.style.labelHeight), titles: self.titles, style: self.style)
        pageTitleView.backgroundColor = .gray
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    //collectionView
    private lazy var collectionView: UICollectionView = {
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height - self.style.labelHeight - (IS_IPhoneX_Series ? 44 : 20))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection:UICollectionView = UICollectionView(frame: CGRect(x: 0, y: self.style.labelHeight + (IS_IPhoneX_Series ? 44 : 20), width: layout.itemSize.width, height: layout.itemSize.height), collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collection.scrollsToTop = false
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        return collection
        
    }()
    
    init(frame: CGRect,
         titles: [String],
         childControllers: [UIViewController],
         parentController: UIViewController,
         style: TYPageStyle = TYPageStyle()){
        
        super.init(frame: frame)
        
        //保存输入
        self.titles = titles
        self.controllers = childControllers
        self.parentVc = parentController
        self.style = style
        
        //初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        //初始化顶部title
        addSubview(pageTitleView)
        
        //初始化CollectionView
        addSubview(collectionView)
    }
}

extension TYPageView : UICollectionViewDelegate,UICollectionViewDataSource{
    
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbideScroll = false
        // 快速滑动细节处理
        
        if Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width) != 0  {
            
            let theNum = collectionView.contentOffset.x / collectionView.bounds.width
            
            let res = self.numFormat(num: Float(theNum ), format: "0")
            //                print(" res",res)
            collectionView.scrollToItem(at: IndexPath(item: Int(res)!, section: 0), at: .left, animated: false)
            
            startOffsetX = collectionView.bounds.width*CGFloat(Float(res)!)
            var direction: MoveDirection = .left

            //判断是左移还是右移
            if startOffsetX > scrollView.contentOffset.x{ //右移动
                direction = .right
            }else{
                direction = .left
            }
            pageTitleView.pageViewScroll(direction: direction, nextIndex: Int(res)!, progress: 1)
            pageTitleView.pageViewScrollEnd(pageIndex: Int(res)!)

        }else{
            startOffsetX = scrollView.contentOffset.x
        }
    }
    
    //四舍五入
    func numFormat(num: Float,format: String) -> String{
        let formatter = NumberFormatter()
        formatter.positiveFormat = format
        return formatter.string(from: NSNumber(value: num))!
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if startOffsetX == scrollView.contentOffset.x { return }
        if isForbideScroll { return}
        
        //scroll滚动的情况下，让item大小变化
        var progress:CGFloat = 0
        var nextIndex = 0
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        var direction: MoveDirection = .left
        
        //判断是左移还是右移scrollViewWillBeginDecelerating
        if startOffsetX > scrollView.contentOffset.x{    //右移动
            nextIndex = currentIndex - 1
            if nextIndex < 0 {
                nextIndex = 0
            }
            //计算progress
            progress = (startOffsetX - scrollView.contentOffset.x)/width
            direction = .right
        }
        if startOffsetX < scrollView.contentOffset.x{    //左移
            
            nextIndex = currentIndex + 1
            if nextIndex > count - 1 {
                nextIndex = count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX)/width
            direction = .left
        }
        pageTitleView.pageViewScroll(direction: direction,nextIndex: nextIndex, progress: progress)
        
    }
    
    //计算currentIndex
    
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
//        设置viewFrame
        currentIndex = index
        //让pageView滚动起来
        pageTitleView.pageViewScrollEnd(pageIndex: index)
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



