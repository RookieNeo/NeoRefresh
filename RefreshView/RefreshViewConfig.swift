//
//  RefreshViewConfig.swift
//  YHCSFINANCE
//
//  Created by Neo on 2017/11/20.
//  Copyright © 2017年 YHCS. All rights reserved.
//

import Foundation
import UIKit
class RefreshViewConfig {
    static let share = RefreshViewConfig()
    var defaultView: (UIView&RefreshStatusChangeProtocol) {
        get{
            return CustomAnimateRefreshView()
        }
    }
    var defaultPullHeight: CGFloat = 60
}

