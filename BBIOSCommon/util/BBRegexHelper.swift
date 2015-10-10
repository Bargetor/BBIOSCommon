//
//  BBRegexHelper.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/31.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

public class RegexHelper {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        do {
            regex = try NSRegularExpression(pattern: pattern,
                options: .CaseInsensitive)
        } catch{
            
            regex = nil
        }
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count)) {
                return matches.count > 0
        } else {
            return false
        }
    }
    
    func find(input: String) -> Array<String>{
        var result = Array<String>()
        if let matches = regex?.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count)){
                for ma in matches{
                    result.append(input.substringWithRange(ma.range))
                }
                return result
        } else {
            return result
        }
    }
}