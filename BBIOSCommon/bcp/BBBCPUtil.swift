//
//  BBBCPUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/24.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import SwiftHTTP
import SwiftyJSON
import ObjectMapper
import XCGLogger

public class BCPRequest: Mappable {
    var bcp: String?
    var id: String?
    //这里不定义成Mappable，是因为编译不通过
    var params: BCPBaseParams?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        bcp    <- map["bcp"]
        id     <- map["id"]
        params <- map["params"]
    }
}

public class BCPBaseParams: Mappable{
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}

public class BCPResponse: Mappable {
    var bcp: String?
    var id: String?
    var result: BCPBaseResult?
    var error: BCPError?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        bcp    <- map["bcp"]
        id     <- map["id"]
        result <- map["result"]
        error  <- map["error"]
    }
}

public class BCPBaseResult: Mappable{
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}

public class BCPError: Mappable {
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

public enum BCPSystemError: ErrorType{
    case NoToken
}


public class BBBCPUtil {
    public static let shareInstance: BBBCPUtil = {
        return BBBCPUtil()
    }()
    
    let logger = XCGLogger.defaultInstance()
    
    /**
    * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
    **/
    public var server: String?
    
    public var username: String = ""
    public var token: String = ""
    
    public init(){
        
    }
    
//    public func request<T: Mappable>(url: String, params: Dictionary<String, AnyObject>, success: ((result: T?, error: BCPError?) -> Void)){
//
//        self.baseRequest(.POST, url: self.buildUrl(url), params: params, paramEncoding: .JSON).response { (request, response, data, error) in
//            
//            self.logger.info("dic params request body is :\(NSString(data: request!.HTTPBody!, encoding: NSUTF8StringEncoding))")
//            
//            if error != nil{
//                self.logger.error(error.debugDescription)
//            }
//            
//            
//            if let d: NSData = data{
//                var json = JSON(data: d)
//                
//                let bcp = json["bcp"].stringValue
//                let id = json["id"].stringValue
//                let resultJson = json["result"]
//                let errorJson = json["error"]
//                let result = Mapper<T>().map(resultJson.description)
//                let error = Mapper<BCPError>().map(errorJson.description)
//                success(result: result, error: error)
//            }
//            
//            
//        }
//    }
    
    
    /**
        result的泛型类型必须为BCPBaseResult的子类，不要以为这里定义的是Mappable你就以为是Mappable
    */
    public func request<T: BCPBaseResult>(urlPath: String, baseParams: BCPBaseParams, success: ((result: T?, error: BCPError?) -> Void)){
        
        let requestBody = self.buildBCPRequestBody()
        requestBody.params = baseParams
        let requestBodyString = Mapper().toJSONString(requestBody, prettyPrint: true)
        self.logger.info("request path: \(urlPath) and base bcp params request body is :\(requestBodyString)")
        
        self.baseRequest(urlPath, params: nil, requestBody: requestBodyString, success: {(response: Response) in
            self.logger.info("base bcp response body is :\(NSString(data: response.data, encoding: NSUTF8StringEncoding))")
            
            if let d: NSData = response.data {
                var json = JSON(data: d)
                
//                let bcp = json["bcp"].stringValue
//                let id = json["id"].stringValue
                let resultJson = json["result"]
                let errorJson = json["error"]
                let result = Mapper<T>().map(resultJson.description)
                let e = Mapper<BCPError>().map(errorJson.description)
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
            self.logger.error("bcp request error:\(error)")
        }
        
    }
    
    /**
    * 创建签名请求参数
    **/
    private func buildSigParams(requestBody: String?) throws -> Dictionary<String, String>{
        if self.token.isEmpty {
            throw BCPSystemError.NoToken
        }
        var params = self.getBaseRequestUrlParams()
        if requestBody != nil{
            params["params"] = requestBody
        }
        
        let sig = self.genSig(params, token: self.token)
        params["sig"] = sig
        print(sig)
        
        params.removeValueForKey("params")
        
        return params
    }
    
    private func genSig(params: Dictionary<String, String>, token: String) -> String{
        let concatParamsString = self.sortAndConcatParams(params)
        let genSigString = "\(concatParamsString)\(token)"
        print(genSigString)
        return genSigString.MD5String()
    }
    
    private func sortAndConcatParams(params: Dictionary<String, String>) -> String{
        let sortResult = params.sort { (element1, element2) -> Bool in
            let result = element1.0.compare(element2.0)
            print("\(element1.0) : \(element2.0) = \(result.rawValue)")
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
    
    private func buildBCPRequestBody() -> BCPRequest{
        let result = BCPRequest()
        result.bcp = "1.0.0"
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

public class BCPDateTransform: DateTransform {

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

