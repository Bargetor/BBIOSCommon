//
//  HTTPHelper.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/3/1.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//
import SwiftHTTP

public enum BBHTTPMethod: String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    case UNKNOWN = "UNKNOWN"
}

public class BBHTTPHelper: NSObject{
    
    public class func get(url: String, params: Dictionary<String, String>?, headers: Dictionary<String, String>?, success: ((Response) -> Void)!, failure: ((NSError, Response?) -> Void)?){
        request(BBHTTPMethod.GET, url: url, params: params, headers: headers, success: success, failure: failure)
    }
    
    public class func post(url: String, params: Dictionary<String, String>?, headers: Dictionary<String, String>?, requestBody:String? = nil, success:((Response) -> Void)!, failure:((NSError, Response?) -> Void)?){
        request(BBHTTPMethod.POST, url: url, params: params, headers: headers, requestBody: requestBody, success: success, failure: failure)
    }
    
    public class func request(method: BBHTTPMethod, url: String, params: Dictionary<String, String>?, headers: Dictionary<String, String>? = nil, requestBody: String? = nil, success:((Response) -> Void)!, failure:((NSError, Response?) -> Void)?){
        if let req = NSMutableURLRequest(urlString: url){
            do{
                if let params = params {
                    let requestSerializer = HTTPParameterSerializer()
                    try requestSerializer.serialize(req, parameters: params)
                }
                req.HTTPMethod = method.rawValue
                if requestBody != nil{
                    let data = requestBody!.dataUsingEncoding(NSUTF8StringEncoding)
                    req.HTTPBody = data
                    req.addValue(String(data?.length), forHTTPHeaderField: "Content-Length")
                }
                
                if let headers = headers{
                    for (key, value) in headers {
                        req.addValue(value, forHTTPHeaderField: key)
                    }
                }
                
                req.timeoutInterval = 10
                
                let opt = HTTP(req)
                opt.start({(response: Response) in
                    success(response)
                })
                
            }catch let error {
                print("couldn't serialize the paraemeters: \(error)")
                if failure != nil{
//                    failure(error, nil)
                }
            }
        }
    }
    
}
