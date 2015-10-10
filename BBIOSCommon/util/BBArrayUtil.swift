//
//  BBArrayUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/8/3.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

extension Array{
    
    func subArrayWithRange(location: Int, length: Int) -> Array<Element>?{
        let count = self.count
        if(location >= count){
            return nil
        }
        var result = Array()
        let rangeEnd = location + length
        let end =  rangeEnd >= count ? count : rangeEnd
        
        for item in self[location ..< end]{
            result.append(item)
        }
        
        return result

    }
}