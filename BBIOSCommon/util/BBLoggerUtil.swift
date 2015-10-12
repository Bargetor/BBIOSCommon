//
//  BBLoggerUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/10/11.
//  Copyright © 2015年 BesideBamboo. All rights reserved.
//

import XCGLogger

public class BBLoggerUtil{
    
    public class func info(closure: String?){
        XCGLogger.info(closure)
    }
    
    public class func error(closure: String?){
        XCGLogger.error(closure)
        
    }
    
    public class func debug(closure: String?){
        XCGLogger.debug(closure)
    }
    
    public class func verbose(closure: String?){
        XCGLogger.verbose(closure)
    }
    
    public class func warning(closure: String?){
        XCGLogger.warning(closure)
    }
    
    public class func severe(closure: String?){
        XCGLogger.severe(closure)
    }
}