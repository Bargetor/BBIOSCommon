//
//  SegueUtil.swift
//  BBIOSCommon
//  转场工具
//  Created by Bargetor on 15/7/26.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

public class BBSegueUtil {
    
    public class func getCurrentViewController() -> UIViewController?{
        var vcResult: UIViewController? = nil
        guard var window = UIApplication.sharedApplication().keyWindow else{
            return vcResult
        }
        
        if window.windowLevel != UIWindowLevelNormal {
            for tempWindow in UIApplication.sharedApplication().windows{
                if tempWindow.windowLevel == UIWindowLevelNormal{
                    window = tempWindow
                    break
                }
            }
        }
        
        guard let frontView = window.subviews.last else{
            return vcResult
        }
        
        var nextResponder = frontView.nextResponder()
        
        while ((nextResponder?.nextResponder()) != nil) {
            nextResponder = nextResponder?.nextResponder()
        }
        
        if nextResponder!.isKindOfClass(UIViewController){
            vcResult = nextResponder as? UIViewController
        }else{
            vcResult = window.rootViewController
        }
        
        return vcResult
        
    }
    
    public class func pushTo(from: UIViewController, to: UIViewController, animated: Bool = true){
        from.navigationController?.pushViewController(to, animated: animated)
    }
    
    public class func pushToMain(from: UIViewController, viewControllerName: String, animated: Bool = true){
        pushTo(from, storyboardName: "Main", viewControllerName: viewControllerName, animated: animated)
    }
    
    public class func pushTo(from: UIViewController, storyboardName: String, viewControllerName: String, animated: Bool = true){
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        let vc = sb.instantiateViewControllerWithIdentifier(viewControllerName)
        
        from.navigationController?.pushViewController(vc, animated: animated)
    }
    
    
    public class func mainStoryboardTo(from: UIViewController, viewControllerName: String, param: AnyObject? = nil){
        storyboardTo(from, storyboardName: "Main", viewControllerName: viewControllerName, param: param)
    }
    
    public class func storyboardTo(from: UIViewController, storyboardName: String, viewControllerName: String, param: AnyObject? = nil){
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        let vc = sb.instantiateViewControllerWithIdentifier(viewControllerName)
        vc.segueParam = param
        
        from.presentViewController(vc, animated: true, completion: nil)
    }
}