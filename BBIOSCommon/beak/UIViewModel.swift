//
//  UIViewModel.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

public protocol UIViewModel {
    
    func bidirectionalBind(component: UIComponent, data: AnyObject?)
    
}