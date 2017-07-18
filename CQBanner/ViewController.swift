//
//  ViewController.swift
//  CQBanner
//
//  Created by Y_CQ on 2017/7/18.
//  Copyright © 2017年 YCQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CQBannerViewDelegate {
    var vBanner: CQBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CQBannerView示例
        vBanner = CQBannerView(frame: CGRect(x: 20, y: 100, width: self.view.bounds.size.width-40, height: 100))
        self.view.addSubview(vBanner)
        vBanner.delegate = self
        vBanner.reloadBanner([
                ["image": "banner"],
                ["image": "http://img.taopic.com/uploads/allimg/140326/235113-1403260U22059.jpg"]
            ])
        
        let btnReload = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 60))
        btnReload.setTitle("刷新", for: UIControlState.normal)
        btnReload.backgroundColor = UIColor.brown
        btnReload.addTarget(self, action: #selector(self.btnReloadClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnReload)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnReloadClick() {
        vBanner.reloadBanner([
                ["image": "http://pic.qiantucdn.com/58pic/11/31/58/97p58PICV26.jpg"],
                ["image": "http://pic27.nipic.com/20130319/10415779_103704478000_2.jpg"],
                ["image": "http://img.taopic.com/uploads/allimg/140326/235113-1403260G01561.jpg"],
                ["image": "http://imgsrc.baidu.com/imgad/pic/item/83025aafa40f4bfb281dbe70094f78f0f63618c0.jpg"],
            ])
    }
    
    //MARK: CQBannerViewDelegate
    func bannerViewDidClick(_ index: Int, model: [String : Any]) {
        print("点击了第\(index)个，对应的model为\(model)")
    }
}

