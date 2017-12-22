//
//  RefreshView_Extension.swift
//  YHCSFINANCE
//
//  Created by Neo on 2017/11/19.
//  Copyright © 2017年 YHCS. All rights reserved.
//

import Foundation
import UIKit
protocol RefreshControl{
    func beginHeaderRefreshing()
    func endHeaderRefreshing()
    func addPullRefresh(_ refreshView : RefreshStatusChangeProtocol & UIView,_ action: @escaping (() ->Void))
}
struct PullDownControl{

    private weak var scroll : UIScrollView!
//    private var refreshViewMaker: RefreshViewMaker!
    init(scroll : UIScrollView) {
        self.scroll = scroll
//        refreshViewMaker = RefreshViewMaker(scrollView: scroll)
    }
    func beginHeaderRefreshing() {
        for subView in scroll.subviews{
            if let refreshView = subView as? UIView & RefreshStatusChangeProtocol{
                refreshView.refreViewMake?.beginHeaderRefreshing()
            }
        }
    }
    func endHeaderRefreshing() {
        for subView in scroll.subviews{
            if let refreshView = subView as? UIView & RefreshStatusChangeProtocol{
                refreshView.refreViewMake?.endHeaderRefreshing()
            }
        }
    }
    func addPullRefresh(_ refreshView: UIView & RefreshStatusChangeProtocol = RefreshViewConfig.share.defaultView, _ action: @escaping (() -> Void)) {
        for subView in scroll.subviews{
            if let refreshView = subView as? (UIView & RefreshStatusChangeProtocol){
                refreshView.removeFromSuperview()
            }
        }
        let refreshViewMaker = RefreshViewMaker(scrollView: scroll)
        refreshViewMaker.addPullRefresh(refreshView, action)
    }
}
extension UIScrollView{
    var pd : PullDownControl
    {
        return PullDownControl(scroll: self)
    }

}













//extension RefreshControl {
//    func beginHeaderRefreshing() {
//        for subView in scroll.subviews{
//            if let refreshViewMaker = subView as? RefreshViewMaker{
//                refreshViewMaker.beginHeaderRefreshing()
//            }
//        }
//    }
//    func endHeaderRefreshing() {
//        for subView in scroll.subviews{
//            if let refreshViewMaker = subView as? RefreshViewMaker{
//                refreshViewMaker.endHeaderRefreshing()
//            }
//        }
//    }
//    func addPullRefresh(_ refreshView: UIView & RefreshStatusChangeProtocol = RefreshViewConfig.share.defaultView, _ action: @escaping (() -> Void)) {
//        for subView in scroll.subviews{
//            if let refreshViewMaker = subView as? RefreshViewMaker{
//                refreshViewMaker.removeFromSuperview()
//            }
//        }
//        let refreshViewMaker = RefreshViewMaker()
//        refreshViewMaker.translatesAutoresizingMaskIntoConstraints = false
//        scroll.addSubview(refreshViewMaker)
//        print(scroll.frame)
//        scroll.addConstraint(NSLayoutConstraint(item: refreshViewMaker, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: scroll, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
//        scroll.addConstraint(NSLayoutConstraint(item: refreshViewMaker, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: scroll, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
//        scroll.addConstraint(NSLayoutConstraint(item: refreshViewMaker, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: scroll, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
//        refreshViewMaker.addConstraint(NSLayoutConstraint(item: refreshViewMaker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: RefreshViewConfig.share.defaultPullHeight))
//        refreshViewMaker.addPullRefresh(refreshView, action)
//    }
//}
