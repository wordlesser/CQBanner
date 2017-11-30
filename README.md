# CQBanner
##  Learning how to use github's readme & practice my first time readme.
        CQBanner is a lightweight banner open source library
##  Requirements
* iOS8.0 or later
* Xcode8 or later
* Swift3.0 or later
------
##  Supported Data Formats
* Local image name
* Net image url
* When your project has SDWebImage, it will use it first， otherwise will use system's network(No caching, suggesting use SDWebImage)

------
##  How To Use
### 0.Drag CQBannerView.swift into your project
### 1.Create bannerView
    let vBanner = CQBannerView(frame: CGRect(x: 20, y: 100, width: self.view.bounds.size.width-40, height: 100))
###    2.Set delegate
    vBanner.delegate = self
###    3.Set datasource
    vBanner.reloadBanner([
            ["image": "banner"],
            ["image": "http://img.taopic.com/uploads/allimg/140326/235113-1403260U22059.jpg"]
        ])
###    4.Implementation delegate
    func bannerViewDidClick(_ index: Int, model: [String : Any]) {
        //do what you want
        print("点击了第\(index)个，对应的model为\(model)")
    }
###    5.Reload datasource
    vBanner.reloadBanner([
        ["image": "http://pic.qiantucdn.com/58pic/11/31/58/97p58PICV26.jpg"],
        ["image": "http://pic27.nipic.com/20130319/10415779_103704478000_2.jpg"],
        ["image": "http://img.taopic.com/uploads/allimg/140326/235113-1403260G01561.jpg"],
        ["image": "http://imgsrc.baidu.com/imgad/pic/item/83025aafa40f4bfb281dbe70094f78f0f63618c0.jpg"],
        ])
##  If you feel better, please give me a star
