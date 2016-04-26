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
    
    /**
     result的泛型类型必须为BPCBaseResult的子类，不要以为这里定义的是Mappable你就以为是Mappable
     */
    public func request<T: BPCBaseResult>(method: String, baseParams: BPCBaseParams, success: ((result: T?, error: BPCError?) -> Void)){
        
        let requestBody = self.buildBPCRequestBody()
        requestBody.method = method
        requestBody.params = baseParams
        let requestBodyString = Mapper().toJSONString(requestBody, prettyPrint: true)
        BBLoggerUtil.info("request method: \(method) -> params request body is :\(requestBodyString)")
        
        self.baseRequest(urlPath!, params: nil, requestBody: requestBodyString, success: {(response: Response) in
            BBLoggerUtil.info("bpc response body is :\(NSString(data: response.data, encoding: NSUTF8StringEncoding))")
            
            if let d: NSData = response.data {
                var json = JSON(data: d)
                
                let resultJson = json["result"]
                let errorJson = json["error"]
                let result = Mapper<T>().map(resultJson.description)
                let e = Mapper<BPCError>().map(errorJson.description)
                
                success(result: result, error: e)
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
    
    private func sortAndConcatParams(params: Dictionary<String, String>) -> String{
        let sortResult = params.sort { (element1, element2) -> Bool in
            let result = element1.0.compare(element2.0)
            return result.rawValue <= 0
        }
        
        var pairs = Array<String>()
        for param in sortResult{
            pairs.append("\(param.0)=\(param.1.urlencode())")
        }
        return pairs.joinWithSeparator("&")
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


public class BBBPCMethod{
    public var method: String
    public var client: BBBPCClient
    
    public init(method: String, client: BBBPCClient){
        self.method = method
        self.client = client
    }
    
    public func send(params: BPCBaseParams) -> BBBPCCallBack<BPCBaseResult>{
        return BBBPCCallBack<BPCBaseResult>(method: self, params: params)
    }
}


public class BBBPCCallBack<T: BPCBaseResult>{
    public var method: BBBPCMethod
    public var params: BPCBaseParams
    public var beforeRequest: (() -> Void)?
    public var afterRequest: ((result: T?, error: BPCError?) -> Void)?
    public var afterCallBack: (() -> Void)?
    
    public init(method: BBBPCMethod, params: BPCBaseParams){
        self.method = method
        self.params = params
    }
    
    public final func callback(block: (result: T?, error: BPCError?) -> Void) -> Void{
        if (self.beforeRequest != nil) {
            beforeRequest!()
        }
        
        self.method.client.request(self.method.method, baseParams: self.params, success: {(result: T?, error: BPCError?) -> Void in
            if (self.afterRequest != nil){
                self.afterRequest!(result: result, error: error)
            }
        
            block(result: result, error: error)
        })
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



