//
//  UIComponent.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

public protocol UIComponent{
    var subComponent: Array<UIComponent>?{ get set }
    
    func initUITemplate(withData: AnyObject?)
    
    func initLayout(withData: AnyObject?)
}


public protocol UIComponentLifecycle{
    
}


extension UIView : UIComponent{
    public var subComponent: Array<UIComponent>?{
        get{
            return self.subComponent
        }
        
        set(newValue){
            self.subComponent = newValue
        }
    }
    
    public func initUITemplate(withData: AnyObject? = nil) {
        
    }
    
    public func initLayout(withData: AnyObject? = nil) {
        
    }
    
}


extension UIView : UIComponentLifecycle{
    
}