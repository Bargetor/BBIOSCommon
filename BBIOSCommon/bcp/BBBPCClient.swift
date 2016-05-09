//
//  BPCClient.swift
//  BBIOSCommon
//
//  Created by Bargetor on 16/4/10.
//  Copyright © 2016年 BesideBamboo. All rights reserved.
//

import SwiftHTTP
import SwiftyJSON
import ObjectMapper
import XCGLogger

public class BBBPCClient{
    
    /**
     * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
     **/
    public var server: String?
    
    public var urlPath: String?
    
    public var userid: Int?
    public var token: String?
    
    public init(){
        
    }

    public func request<T: Mappable>(method: String, params: BPCParams, success: ((result: T?, error: BPCError?) -> Void)?){
        self.baseRequest(method, params: params, success: {(resultJson, errorJson) -> Void in
            let result = Mapper<T>().map(resultJson.description)
            let e = Mapper<BPCError>().map(errorJson.description)
            
            if let success = success{
                success(result: result, error: e)
            }
            
            
        })
    }
    
    public func requestArray<T: Mappable>(method: String, params: BPCParams, success: ((results: [T]?, error: BPCError?) -> Void)?){
        self.baseRequest(method, params: params, success: {(resultJson, errorJson) -> Void in
            let results = Mapper<T>().mapArray(resultJson.description)
            let e = Mapper<BPCError>().map(errorJson.description)
            if let success = success{
                success(results: results, error: e)
            }
        })
    }
    
    public func baseRequest(method: String, params: BPCParams, success: (resultJson: JSON, errorJson: JSON) -> Void){
        
        let requestBody = self.buildBPCRequestBody()
        requestBody.method = method
        requestBody.params = params
        let requestBodyString = Mapper().toJSONString(requestBody, prettyPrint: false)
        BBLoggerUtil.info("request method: \(method) -> params request body is :\(requestBodyString)")
        
        self.baseRequest(urlPath!, params: nil, requestBody: requestBodyString, success: {(response: Response) in
            BBLoggerUtil.info("bpc response body is :\(NSString(data: response.data, encoding: NSUTF8StringEncoding))")
            
            if let d: NSData = response.data {
                var json = JSON(data: d)
                
                let resultJson = json["result"]
                let errorJson = json["error"]
                
                success(resultJson: resultJson, errorJson: errorJson)
            }
        })
    }
    
    public func baseRequest(urlPath: String, params: Dictionary<String, String>?, requestBody: String? = nil, success: ((response: Response) -> Void)){
        BBHTTPHelper.post(self.buildUrl(urlPath), params: params, headers: self.buildRequestHeader(), requestBody: requestBody, success: {response in
            success(response: response)
        }, failure: nil)
    }
    
    private func buildMethod(method: String){
        
    }
    
    private func getBaseRequestUrlParams() -> Dictionary<String, String>{
        var params = Dictionary<String, String>()
        params["timestamp"] = NSDate().timeIntervalSince1970.description
        return params
    }
    
    private func buildBPCRequestBody() -> BPCRequest{
        let result = BPCRequest()
        result.bpc = "1.0.0"
        result.id = NSUUID().UUIDString
        result.userid = userid
        result.api = "1.0"
        result.token = token
        return result
    }
    
    /**
     * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
     **/
    private func buildUrl(url: String) -> String{
        if self.server != nil {
            return self.server! + url
        }
        return url
    }
    
    private func buildRequestHeader() -> Dictionary<String, String>!{
        var header: Dictionary<String, String> = Dictionary<String, String>()
        header["Content-Type"] = "application/json;charset=utf-8"
        return header
    }
    
}

public class BBBPCMethodGroup{
    public var client: BBBPCClient
    
    public init(client: BBBPCClient){
        self.client = client
    }
}

public protocol BBBPCMethodProtocol{
    associatedtype ResultType
    
    func callback(callback: (result: ResultType?, error: BPCError?) -> Void)
    
    func request(params: BPCParams)
    
    func beforeRequest()
    
    func afterRequest(result: ResultType?, error: BPCError?)
    
    func afterCallBack(result: ResultType?, error: BPCError?)
    
}

public class BBBPCMethod<R: Mappable> : BBBPCMethodProtocol{
    public typealias ResultType = R
    
    public var method: String
    public var client: BBBPCClient
    private var callback: ((result: ResultType?, error: BPCError?) -> Void)?
    
    public init(method: String, client: BBBPCClient){
        self.method = method
        self.client = client
    }
    
    public func callback(callback: (result: ResultType?, error: BPCError?) -> Void) {
        self.callback = callback
    }
    
    public final func request(params: BPCParams) {
        self.beforeRequest()
        
        self.client.request(self.method, params: params, success: {(result: ResultType?, error) -> Void in
            self.afterRequest(result, error: error)
            if let callback = self.callback{
                callback(result: result, error: error)
            }
            self.afterCallBack(result, error: error)
        })
    }

    public func buildRequester<T: BBBPCMethodProtocol>(method: T, params: BPCParams) -> BBBPCRequester<T>{
        return BBBPCRequester<T>(method: method, params: params)
    }
    
//    public final func buildRequester(params: Mappable) -> BBBPCRequester<BBBPCMethod<R>>{
//        return BBBPCRequester<BBBPCMethod<R>>(method: self, params: params)
//    }
    
    public func beforeRequest(){}
    
    public func afterRequest(result: ResultType?, error: BPCError?){}
    
    public func afterCallBack(result: ResultType?, error: BPCError?){}
}

public class BBBPCMethodForArray<R: Mappable>: BBBPCMethodProtocol{
    public typealias ResultType = [R]
    
    public var method: String
    public var client: BBBPCClient
    private var callback: ((result: ResultType?, error: BPCError?) -> Void)?
    
    public init(method: String, client: BBBPCClient){
        self.method = method
        self.client = client
    }
    
    public func callback(callback: (result: ResultType?, error: BPCError?) -> Void) {
        self.callback = callback
    }
    
    public final func request(params: BPCParams) {
        self.beforeRequest()
        
        self.client.requestArray(self.method, params: params, success: {(result: ResultType?, error) -> Void in
            self.afterRequest(result, error: error)
            if let callback = self.callback{
                callback(result: result, error: error)
            }
            self.afterCallBack(result, error: error)
        })
    }
    
    public func buildRequester<T: BBBPCMethodProtocol>(method: T, params: BPCParams) -> BBBPCRequester<T>{
        return BBBPCRequester<T>(method: method, params: params)
    }
    
    public func beforeRequest(){}
    
    public func afterRequest(result: ResultType?, error: BPCError?){}
    
    public func afterCallBack(result: ResultType?, error: BPCError?){}
}

public class BBBPCRequester<T: BBBPCMethodProtocol>{
    public var method: T
    public var params: BPCParams
    
    public init(method: T, params: BPCParams){
        self.method = method
        self.params = params
    }
    
    public func callback(callback: (result: T.ResultType?, error: BPCError?) -> Void){
        self.method.callback(callback)
        self.method.request(self.params)
    }
}


public class BPCDateTransform: DateTransform {
    
    public override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeInt = value as? Double {
            let date = NSDate(timeIntervalSince1970: NSTimeInterval(timeInt / 1000.0))
            let zone = NSTimeZone.systemTimeZone()
            let interval = NSTimeInterval(zone.secondsFromGMTForDate(date))
            return date.dateByAddingTimeInterval(interval)
        }
        return nil
    }
    
    public override func transformToJSON(value: NSDate?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970) * 1000.0
        }
        return nil
    }
}



