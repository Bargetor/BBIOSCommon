//
//  BBArrayUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/8/3.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

extension Array{
    
    public func subArrayWithRange(location: Int, length: Int) -> Array<Element>?{
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
    
    public func toUnsafeMutablePointer() -> UnsafeMutablePointer<Element>{
        let points: UnsafeMutablePointer<Element> = UnsafeMutablePointer.alloc(self.count)
        for i in 0 ..< self.count{
            let item = self[i]
            points[i] = item
        }
        
        return points
    }
    
    public mutating func appendAll(elements: [Element]?){
        guard let elements = elements else{
            return
        }
        
        for element in elements{
            self.append(element)
        }
    }
}

extension Array where Element: Equatable {
    
    /**
     从array中删除一个对象
     
     - parameter object: 要删除的对象
     */
    public mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
}