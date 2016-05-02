//
//  BBSegue.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/26.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import ObjectiveC

public var lastSegueParam: AnyObject?

extension UIViewController{
    public var segueParam: AnyObject?{
        get{
            return objc_getAssociatedObject(self, &lastSegueParam)
        }
        set(newValue){
            objc_setAssociatedObject(self, &lastSegueParam, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func pushTo(to: UIViewController, params: AnyObject? = nil){
        BBSegueUtil.pushTo(self, to: to, params: params)
    }
    
    public func pop(){
        BBSegueUtil.pop(self)
    }
}

extension UIView{
    
    public func mainStoryboardTo(viewControllerName: String, param: AnyObject? = nil){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        BBSegueUtil.mainStoryboardTo(vc, viewControllerName: viewControllerName, param: param)
    }
    
    public func pushTo(to: UIViewController, params: AnyObject? = nil){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        
        BBSegueUtil.pushTo(vc, to: to, params: params)
    }
    
    
}