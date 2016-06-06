//
//  UIViewModel.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

@objc public protocol UIViewModel{
    //init function 不能有任何数据加载的代码，否则很容易导致在UI未绑定前，数据已经更新
    
//    func bidirectionalBind(component: UIComponent, data: AnyObject?)
    
}