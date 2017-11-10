//
//  CQBannerView.swift
//  CQBanner
//
//  Created by Y_CQ on 2017/7/18.
//  Copyright © 2017年 YCQ. All rights reserved.
//  此banner只用于处理常规任务，当点击某一张图片时会通过代理回传相应的index和原始数据

import UIKit
protocol CQBannerViewDelegate: class {
    func bannerViewDidClick(_ index: Int, model: [String: Any])
}
class CQBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var cellId = "CQBannerCell"
    private var datasource: [[String: Any]] = []
    private var vCollection: UICollectionView!
    private var pageControl: UIPageControl!
    private var timer: Timer!
    private var timeInterval: TimeInterval = 3
    private var currentPage = 0
    weak var delegate: CQBannerViewDelegate?=nil
    
    
    /// 刷新整个banner
    ///
    /// - Parameter models: banner数据，图片资源格式为key=image，value=(url||imageName)，如果为网络资源当判断当前工程已有SDWebImage时会自动使用SDWebImage处理图片，如果没有会用原生请求处理数据格式如后所示[["image": "imageName(图片名称)"], ["image": "http://xxxxx（网络资源）"]]
    func reloadBanner(_ models: [[String: Any]]) {
        self.datasource = models
        if self.datasource.count <= 0 {
            print("warning: datasource is empty!")
            return
        }
        self.currentPage = 0
        self.vCollection.reloadData()
        self.vCollection.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        self.reloadPageControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    
    deinit {
        self.deinitTimer()
    }
    override func layoutSubviews() {
        vCollection.frame = self.bounds
        self.vCollection.reloadData()
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        vCollection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(vCollection)
        vCollection.register(CQBannerCell.self, forCellWithReuseIdentifier: cellId)
        vCollection.dataSource = self
        vCollection.delegate = self
        vCollection.isPagingEnabled = true
        vCollection.showsHorizontalScrollIndicator = false
        vCollection.showsVerticalScrollIndicator = false
        vCollection.backgroundColor = UIColor.white
        
        let pageControlW: CGFloat = 100
        let pageControlH: CGFloat = 20
        
        pageControl = UIPageControl(frame: CGRect(x: (self.bounds.size.width-pageControlW)/2, y: self.bounds.size.height-pageControlH - 5, width: pageControlW, height: pageControlH))
        self.addSubview(pageControl)
        pageControl.numberOfPages = self.datasource.count
        pageControl.currentPage = currentPage
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.timerHandler(_:)), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    //MARK: timer
    func timerHandler(_ timer: Timer) {
        if self.datasource.count == 0 {
            return
        }
        self.currentPage+=1
        var animated = true
        if self.currentPage > self.datasource.count-1 {
            animated = false
            self.currentPage = 0
        }
        self.reloadPageControl()
        let indexPath = IndexPath(item: currentPage, section: 0)
        self.vCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: animated)
    }

    /// 释放定时器
    private func deinitTimer() {
        if self.timer != nil {
            self.timer?.fireDate = Date.distantFuture
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    
    /// 刷新pageControl
    private func reloadPageControl() {
        pageControl.numberOfPages = self.datasource.count
        pageControl.currentPage = currentPage
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CQBannerCell
        let model = self.datasource[indexPath.item]
        cell.fillData(indexPath, model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let indexPaths = collectionView.indexPathsForVisibleItems
        if indexPaths.count < 1 {
            return
        }
        let currentIndex = indexPaths[0]
        self.currentPage = currentIndex.item
        self.reloadPageControl()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.datasource[indexPath.item]
        self.delegate?.bannerViewDidClick(indexPath.item, model: model)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //用户操作后暂停定时器
        self.timer.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //用户操作完成后，延时timeInterval后重启定时器
        let t = Date().timeIntervalSince1970 + timeInterval
        let date = Date(timeIntervalSince1970: t)
        self.timer.fireDate = date
    }
}


class CQBannerCell: UICollectionViewCell {
    var ivImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.contentView.backgroundColor = UIColor.white
        ivImage = UIImageView(frame: self.bounds)
        self.contentView.addSubview(ivImage)
    }
        
    func fillData(_ indexPath: IndexPath, model: [String: Any]) {
        let image = model["image"] as? String ?? ""
        if image.contains("http://") || image.contains("https://") {
            let imageStr = image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if let url = URL(string: imageStr) {
                let selector = NSSelectorFromString("sd_setImageWithURL:")
                if ivImage.responds(to: selector) {
                    ivImage.perform(selector, with: url)
                }else {
                    DispatchQueue.global().async {
                        do {
                            let data = try Data(contentsOf: url)
                            let img = UIImage(data: data)
                            DispatchQueue.main.async { [weak self] in
                                if self == nil {
                                    return
                                }
                                let sSelf = self!
                                sSelf.ivImage.image = img
                            }
                        }catch {
                            print("\(error)")
                        }
                    }
                }
            }else {
                print("可能链接没有转码或转码失败")
            }
        }else {
            ivImage.image = UIImage(named: image)
        }
    }
}

