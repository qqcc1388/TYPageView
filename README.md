# TYPageView

##TYPageView 类似今日头条 的标签导航解决方案,支持多种样式选择，基于swift3.0,支持文字颜色动态变化，底部选中线的动态变化

##配图：

![](https://github.com/qqcc1388/TYPageView/blob/master/source/QQ20170522-131618.gif)

##使用方法：
`
        let titles = ["推荐","热点","健身","海贼王","大闹天宫","推荐","热点","健身","海贼王","大闹天宫"]
        var childsVc:[UIViewController] = [UIViewController]()
        for _ in 0..<titles.count {
            let contentVc = TYContentController()  //控制器管理
            childsVc.append(contentVc)
        }
        let pageView = TYPageView(frame: view.bounds, titles: titles, childControllers: childsVc, parentController: self)
        view.addSubview(pageView)
`

##设置属性TYPageStyle（不传入样式，使用默认属性）
`
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
`
##设置label布局样式
`
enum LabelLayout {
    case scroll   //可以滚动
    case divide   //不可以滚动，所有label均分
    case center   //居中，不可以滚动
}
`

