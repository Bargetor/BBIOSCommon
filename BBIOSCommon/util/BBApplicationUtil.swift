//
//  BBApplicationUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/8/4.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

public class BBApplicationUtil{
    public class func getApplicationFrame() -> CGRect{
        return UIScreen.mainScreen().applicationFrame
    }
}