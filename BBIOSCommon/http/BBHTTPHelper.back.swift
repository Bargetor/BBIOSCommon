//
//  HTTPHelper.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/3/1.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation
import SwiftHTTP
import Alamofire

public class BBHTTPHelper: NSObject{
    
    public class func get(url: String, params: Dictionary<String, String>?, headers: Dictionary<String, String>?, success: ((HTTPResponse) -> Void)!, failure: ((NSError, HTTPResponse?) -> Void)?){
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        if (headers != nil) {
            request.requestSerializer.headers = headers!
        }
        request.GET(url, parameters: params, success: success, failure: failure)
    }
    
    public class func post(url: String, params: Dictionary<String, String>?, headers: Dictionary<String, String>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)?){
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        if (headers != nil) {
            request.requestSerializer.headers = headers!
        }
        request.POST(url, parameters: params, success: success, failure: failure)
    }
    
//    public class func get(url: String) -> Request{
//        return request(.GET, url: url, headers: nil, params: nil, paramEncoding: nil)
//    }
//    
//    public class func post(url: String) -> Request{
//        return request(.POST, url: url, headers: nil, params: nil, paramEncoding: nil)
//    }
//    
//    public class func get(url: String, params: Dictionary<String, AnyObject>) -> Request{
//        return request(.GET, url: url, headers: nil, params: params, paramEncoding: nil)
//    }
//    
//    public class func post(url: String, params: Dictionary<String, AnyObject>) -> Request{
//        return request(.POST, url: url, headers: nil, params: params, paramEncoding: nil)
//    }
    
    public class func get(url: String, params: Dictionary<String, AnyObject>? = nil) -> Request{
        return request(.GET, url: url, params: params, paramEncoding: nil)
    }
    
    public class func post(url: String, params: Dictionary<String, AnyObject>? = nil) -> Request{
        return request(.POST, url: url, params: params, paramEncoding: nil)
    }
    
    public class func postForJson(url: String, params: Dictionary<String, AnyObject>? = nil) -> Request{
        return request(.POST, url: url, params: params, paramEncoding: .JSON)
    }
    
    public class func request(method: Alamofire.Method, url: String, params: Dictionary<String, AnyObject>?, paramEncoding: ParameterEncoding?) -> Request{
        if !(paramEncoding != nil){
            return Alamofire.request(method, url, parameters: params)
        }else{
            return Alamofire.request(method, url, parameters: params, encoding: paramEncoding!)
        }
    }
    
    
    public class func buildHeaderAlamofireManager(headers: Dictionary<String, String>) -> Manager{
        
        let configuration: NSURLSessionConfiguration = Manager.sharedInstance.session.configuration.copy() as! NSURLSessionConfiguration
        var headersConfig = Manager.defaultHTTPHeaders
        
        for (key, value) in headers{
            headersConfig[key] = value
        }

        configuration.HTTPAdditionalHeaders = headersConfig
        return Manager(configuration: configuration)
    }
    
}
