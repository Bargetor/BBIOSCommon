//
//  Binder.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/29.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import Foundation
import Bond

public class Binder{
    
    public init(){
        
    }
    
    public func bind<T>(bind: T) -> BindTo<T>{
        return BindTo<T>(bind: bind)
    }
    
}

public class BindTo<T>{
    var bind: T
    
    public init(bind: T){
        self.bind = bind
    }
    
    public func to(to: T){
        let bindObservable = Observable<T>(bind)
        let bindToObservable = Observable<T>(to)
        
        bindObservable.bidirectionalBindTo(bindToObservable)
    }
}