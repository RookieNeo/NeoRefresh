//
//  CustomAnimateRefreshView.swift
//  YHCSFINANCE
//
//  Created by Neo on 2017/12/5.
//  Copyright © 2017年 YHCS. All rights reserved.
//

import Foundation
import UIKit
class CustomAnimateRefreshView : UIView,RefreshStatusChangeProtocol{
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    var type : RefreshStatus = .pullToRefresh
    func refreshStatusChange(type: RefreshStatus) {
        self.type = type
    }
    let endPoint: CGFloat = 0.98
    let startPoint: CGFloat = 0.02
    func refreshContentOffset(_ contentOffset: CGPoint) {
        switch type {
        case .pullToRefresh:
            if contentOffset.y <= 0 && contentOffset.y >= -60{
                let double = (abs(contentOffset.y))/60.0
                sublayer.strokeEnd = double > endPoint ? endPoint : double
            }else if contentOffset.y > 0{
                sublayer.strokeEnd = startPoint
            }else if contentOffset.y < -60 {
                sublayer.strokeEnd = endPoint
            }
            sublayer.removeAllAnimations()
            gra.removeAllAnimations()
            print("移除动画")
        case .releaseToRefresh:
            sublayer.strokeEnd = endPoint
            if !((gra.animationKeys() ?? []).contains("transform.rotation.z")){
                let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
                rotate.fromValue = 0
                rotate.toValue = Double.pi * 2
                rotate.duration = 2
                rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                rotate.repeatCount = MAXFLOAT
                rotate.fillMode = kCAFillModeForwards
                rotate.isRemovedOnCompletion = false
                gra.add(rotate, forKey: rotate.keyPath)
                print("添加动画成功")
            }else{
                print("已经添加动画了")
            }
        case .loading:
            if !((sublayer.animationKeys() ?? []).contains("group")){
                let testAn = CAKeyframeAnimation(keyPath: "strokeEnd")
                testAn.values = [startPoint,endPoint,endPoint]
                testAn.duration = 2
                testAn.isRemovedOnCompletion = true
                testAn.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
                testAn.repeatCount = MAXFLOAT
                testAn.fillMode = kCAFillModeRemoved
                self.sublayer.add(testAn, forKey: testAn.keyPath)
//
                let testAn1 = CAKeyframeAnimation(keyPath: "strokeStart")
                testAn1.values = [startPoint,startPoint,endPoint]
                testAn1.duration = 2
                testAn1.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
                testAn1.isRemovedOnCompletion = true
                testAn1.repeatCount = MAXFLOAT
                testAn1.fillMode = kCAFillModeRemoved

                let group = CAAnimationGroup()
                group.animations = [testAn,testAn1]
                group.duration = 2
                group.repeatCount = MAXFLOAT
                group.fillMode = kCAFillModeForwards
                self.sublayer.add(group, forKey: "group")
            }
        }
    }
    let sublayer=CAShapeLayer()
    let gra = CAGradientLayer()
    let lineWidth : CGFloat = 3
    let length : CGFloat = 30
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: CGRect(x: lineWidth/2, y:lineWidth/2, width: length, height: length), cornerRadius: length/2)
        sublayer.path = path.cgPath
        print(sublayer.frame)
        sublayer.lineWidth = lineWidth
        sublayer.strokeStart = startPoint
        sublayer.strokeEnd = startPoint
        sublayer.lineCap = kCALineCapRound
        sublayer.fillColor = UIColor.clear.cgColor
        sublayer.strokeColor = UIColor.blue.cgColor
        print(sublayer.transform)
        let image = UIImage(named: "angle-mask")
        //        sublayer.contents = image?.cgImage
        //        self.layer.addSublayer(sublayer)
        
        gra.colors = [UIColor.gray.cgColor,UIColor.clear.cgColor]
        gra.locations = [0.4,1]
        gra.bounds = CGRect(x: 0, y: 0, width: (length + lineWidth), height: (length + lineWidth))
        gra.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        gra.startPoint = CGPoint(x: 0, y: 1)
        gra.endPoint = CGPoint(x: 1, y: 0)
        gra.contents = image?.cgImage
        gra.mask = sublayer//  通过mask属性来截取渐变曾
        self.layer.addSublayer(gra)
    }
    var refreViewMake: RefreshControl?
}

