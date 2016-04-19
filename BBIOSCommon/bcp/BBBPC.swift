//
//  BBBPCUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/24.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import SwiftHTTP
import SwiftyJSON
import ObjectMapper
import XCGLogger

public class BPCRequest: Mappable {
    var bpc: String?
    var id: String?
    var userid: Int?
    var method: String?
    var api: String?
    var token: String?
    //这里不定义成Mappable，是因为编译不通过
    var params: BPCBaseParams?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        bpc    <- map["bpc"]
        id     <- map["id"]
        method <- map["method"]
        userid <- map["userid"]
        api    <- map["api"]
        token  <- map["token"]
        params <- map["params"]
    }
}

public class BPCBaseParams: Mappable{
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}

public class BPCResponse: Mappable {
    var bpc: String?
    var id: String?
    var result: BPCBaseResult?
    var error: BPCError?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        bpc    <- map["bpc"]
        id     <- map["id"]
        result <- map["result"]
        error  <- map["error"]
    }
}

public class BPCBaseResult: Mappable{
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}

public class BPCError: Mappable {
    public var status: Int?
    public var msg: String?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        status  <- map["status"]
        msg     <- map["msg"]
    }
}


public class BBBPCUtil {
    public static let shareInstance: BBBPCUtil = {
        return BBBPCUtil()
    }()
    
    /**
    * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
    **/
    public var server: String?
    
    public var username: String = ""
    public var token: String = ""
    
    public init(){
        
    }
    
    /**
        result的泛型类型必须为BPCBaseResult的子类，不要以为这里定义的是Mappable你就以为是Mappable
    */
    public func request<T: BPCBaseResult>(urlPath: String, baseParams: BPCBaseParams, success: ((result: T?, error: BPCError?) -> Void)){
        
        let requestBody = self.buildBPCRequestBody()
        requestBody.params = baseParams
        let requestBodyString = Mapper().toJSONString(requestBody, prettyPrint: true)
        BBLoggerUtil.info("request path: \(urlPath) || and base BPC params request body is :\(requestBodyString)")
        
        self.baseRequest(urlPath, params: nil, requestBody: requestBodyString, success: {(response: Response) in
            BBLoggerUtil.info("base BPC response body is :\(NSString(data: response.data, encoding: NSUTF8StringEncoding))")
            
            if let d: NSData = response.data {
                var json = JSON(data: d)
                
//                let BPC = json["BPC"].stringValue
//                let id = json["id"].stringValue
                let resultJson = json["result"]
                let errorJson = json["error"]
                let result = Mapper<T>().map(resultJson.description)
                let e = Mapper<BPCError>().map(errorJson.description)
                success(result: result, error: e)
            }
        })
    }

    public func baseRequest(urlPath: String, params: Dictionary<String, String>?, requestBody: String? = nil, success: ((response: Response) -> Void)){
        do{
            let params = try self.buildSigParams(requestBody)
            
            BBHTTPHelper.post(self.buildUrl(urlPath), params: params, headers: self.buildRequestHeader(), requestBody: requestBody, success: {response in
                success(response: response)
            }, failure: nil)
        }catch let error{
            BBLoggerUtil.error("BPC request error:\(error)")
        }
        
    }
    
    /**
    * 创建签名请求参数
    **/
    private func buildSigParams(requestBody: String?) throws -> Dictionary<String, String>{
        var params = self.getBaseRequestUrlParams()
        if requestBody != nil{
            params["params"] = requestBody
        }
        
        let sig = self.genSig(params, token: self.token)
        params["sig"] = sig
        
        params.removeValueForKey("params")
        
        return params
    }
    
    private func genSig(params: Dictionary<String, String>, token: String) -> String{
        let concatParamsString = self.sortAndConcatParams(params)
        let genSigString = "\(concatParamsString)\(token)"
        return genSigString.MD5String()
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
        params["username"] = self.username
        params["timestamp"] = NSDate().timeIntervalSince1970.description
        return params
    }
    
    private func buildBPCRequestBody() -> BPCRequest{
        let result = BPCRequest()
        result.bpc = "1.0.0"
        result.id = NSUUID().UUIDString
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
        header["username"] = self.username
        header["token"] = self.token
        header["appname"] = "stars"
        header["api"] = "1"
        return header
    }
    
}

