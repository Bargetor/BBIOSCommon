//
//  UIComponent.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

@objc public protocol UIComponent{
    var subComponent: Array<UIComponent>?{ get set }
    
    func initUITemplate(withViewModel: UIViewModel?)
    
    func bindViewModel(viewModel withViewModel: UIViewModel?)
    
    func layout()
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
    
    public func initUITemplate(withViewModel: UIViewModel? = nil) {
        for subView in self.subviews {
            subView.initUITemplate(withViewModel)
        }
    }
    
    public func bindViewModel(viewModel withViewModel: UIViewModel? = nil){
        
    }
    
    public func layout() {
        for subView in self.subviews {
            subView.layout()
        }
    }
    
}


extension UIView : UIComponentLifecycle{
    
}