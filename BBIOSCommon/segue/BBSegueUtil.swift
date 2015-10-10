//
//  SegueUtil.swift
//  BBIOSCommon
//  转场工具
//  Created by Bargetor on 15/7/26.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

public class BBSegueUtil {
    
    public class func mainStoryboardTo(from: UIViewController, viewControllerName: String){
        BBSegueUtil.storyboardTo(from, storyboardName: "Main", viewControllerName: viewControllerName)
    }
    
    public class func storyboardTo(from: UIViewController, storyboardName: String, viewControllerName: String){
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        let vc = sb.instantiateViewControllerWithIdentifier(viewControllerName) 
        
        from.presentViewController(vc, animated: true, completion: nil)
    }
}