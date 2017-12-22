//
//  RefreshViewMaker.swift
//  YHCSFINANCE
//
//  Created by Neo on 2017/11/19.
//  Copyright © 2017年 YHCS. All rights reserved.
//

import UIKit

@objc enum RefreshStatus: Int{
    case loading
    case pullToRefresh
    case releaseToRefresh
}
class RefreshViewMaker: UIView,RefreshControl {
    private var pullHeight: CGFloat {
        get{
            return RefreshViewConfig.share.defaultPullHeight
        }
    }
    private var type = RefreshStatus.pullToRefresh{
        didSet{
            if oldValue != type{
                refreshView?.refreshStatusChange(type: type)
            }
        }
    }
    private var action : (() -> Void)?
    private var scrollView: UIScrollView!
    private var refreshView : (UIView & RefreshStatusChangeProtocol)?

    init(scrollView : UIScrollView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.scrollView = scrollView
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.scrollView.removeObserver(self, forKeyPath: "contentOffset")
        print("asdasdadsasd")
    }
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - refreshView: 既是UIView也实现了RefreshStatusChangeProtocol
    ///   - action: 刷新时要调用的方法
    func addPullRefresh( _ refreshView: (UIView & RefreshStatusChangeProtocol), _ action: @escaping (() ->Void)){
        self.action = action
        self.refreshView = refreshView
        self.refreshView?.refreViewMake = self
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(refreshView)
        print(self.scrollView.frame,UIScreen.main.bounds)

        self.scrollView.addConstraint(NSLayoutConstraint(item: refreshView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: refreshView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: refreshView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        refreshView.addConstraint(NSLayoutConstraint(item: refreshView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: pullHeight))
        self.scrollView.addConstraint(NSLayoutConstraint(item: refreshView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
    }
    func endHeaderRefreshing() {
        type = .pullToRefresh
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func beginHeaderRefreshing() {
        type = .loading
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -pullHeight), animated: true)
        action?()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath,path == "contentOffset"{
            let contontMaxY = -(pullHeight + (scrollView.contentInset.top))
            let y = scrollView.contentOffset.y
            refreshView?.refreshContentOffset(scrollView.contentOffset)
            //拖拽
            if scrollView.isDragging{
                if y > contontMaxY{
                    type = .pullToRefresh
                }else{
                    type = .releaseToRefresh
                }
            }else{
            //松手
                if type == .releaseToRefresh{
                    self.beginHeaderRefreshing()
                }
            }
        }
    }

}
