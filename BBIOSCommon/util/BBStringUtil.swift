//
//  BBStringUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/31.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

extension String {
    
    func substringWithRange(range: NSRange) -> String! {
        let r = Range<String.Index>(start: self.startIndex.advancedBy(range.location), end: self.startIndex.advancedBy(range.location + range.length))
        return self.substringWithRange(r)
    }
        
    func urlencode() -> String {
        let urlEncoded = self.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let chartset = NSMutableCharacterSet(bitmapRepresentation: NSCharacterSet.URLQueryAllowedCharacterSet().bitmapRepresentation)
        chartset.removeCharactersInString("!*'();:@&=$,/?%#[]")
        return urlEncoded.stringByAddingPercentEncodingWithAllowedCharacters(chartset)!
    }
}