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
}

extension UIView{
    
    public func mainStoryboardTo(viewControllerName: String, param: AnyObject? = nil){
        guard let vc = BBSegueUtil.getCurrentViewController() else{
            return
        }
        BBSegueUtil.mainStoryboardTo(vc, viewControllerName: viewControllerName, param: param)
    }
}