//
//  BBDateUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/25.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation

public class BBDateUtil{
    public class func getDateString(date: NSDate, formatStr: String) -> String{
        print(date)
        let format = NSDateFormatter()
        format.dateFormat = formatStr
        return format.stringFromDate(date)
    }
}