//
//  BBBCPUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/24.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON
import ObjectMapper
import Alamofire
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


public class BBBCPUtil {
    public static let shareInstance: BBBCPUtil = {
        return BBBCPUtil()
    }()
    
    let logger = XCGLogger.defaultInstance()
    
    var manager: Manager!
    
    /**
    * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
    **/
    public var server: String?
    
    public var username: String = "" {
        didSet{
            self.refreshHeader()
        }
    }
    public var token: String = "" {
        didSet{
            self.refreshHeader()
        }
    }
    
    public init(){
        self.manager = BBHTTPHelper.buildHeaderAlamofireManager(self.buildRequestHeader())
    }
    
    public func request<T: Mappable>(url: String, params: Dictionary<String, AnyObject>, success: ((result: T?, error: BCPError?) -> Void)){
        
        self.baseRequest(.POST, url: self.buildUrl(url), params: params, paramEncoding: .JSON).response { (request, response, data, error) in
            
            self.logger.info("dic params request body is :\(NSString(data: request!.HTTPBody!, encoding: NSUTF8StringEncoding))")
            
            if error != nil{
                self.logger.error(error.debugDescription)
            }
            
            
            if let d: NSData = data{
                var json = JSON(data: d)
                
//                let bcp = json["bcp"].stringValue
//                let id = json["id"].stringValue
                let resultJson = json["result"]
                let errorJson = json["error"]
                let result = Mapper<T>().map(resultJson.description)
                let error = Mapper<BCPError>().map(errorJson.description)
                success(result: result, error: error)
            }
            
            
        }
    }
    
    
    /**
        result的泛型类型必须为BCPBaseResult的子类，不要以为这里定义的是Mappable你就以为是Mappable
    */
    public func request<T: Mappable>(url: String, baseParams: BCPBaseParams, success: ((result: T?, error: BCPError?) -> Void)){
        
        var requestBody = self.buildBCPRequestBody()
        requestBody.params = baseParams
        
        var request = self.baseRequest(.POST, url: self.buildUrl(url), params: [:], paramEncoding: ParameterEncoding.Custom({(convertible, params) in
            var mutableRequest: NSMutableURLRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            var requestBodyString = Mapper().toJSONString(requestBody, prettyPrint: true)
            mutableRequest.HTTPBody = requestBodyString!.dataUsingEncoding(NSUTF8StringEncoding)
            
            self.setHeaderForRequest(mutableRequest)
            
            return (mutableRequest, nil)
        }))
        
        
        request.response{(request, response, data, error) in
            
            self.logger.info("base bcp params request body is :\(NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding))")
            self.logger.info("base bcp response body is :\(NSString(data: data as! NSData, encoding: NSUTF8StringEncoding))")
            
            if error != nil{
                self.logger.error(error?.description)
            }
            
            if let d: NSData = data {
                var json = JSON(data: d)
                
                let bcp = json["bcp"].stringValue
                let id = json["id"].stringValue
                let resultJson = json["result"]
                let errorJson = json["error"]
                let result = Mapper<T>().map(resultJson.description)
                let e = Mapper<BCPError>().map(errorJson.description)
                success(result: result, error: e)
            }
        }
    }

    public func baseRequest(method: Alamofire.Method, url: String, params: Dictionary<String, AnyObject>?, paramEncoding: ParameterEncoding = ParameterEncoding.URL) -> Request{
        return self.manager.request(method, url, parameters: params, encoding: paramEncoding)
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
    
    private func refreshHeader(){
        var headers = self.manager.session.configuration.HTTPAdditionalHeaders ?? [:]
        let newHeaders = self.buildRequestHeader()
        for (key, value) in newHeaders{
            headers[key] = value
        }
        self.manager.session.configuration.HTTPAdditionalHeaders = headers
    }
    
    private func setHeaderForRequest(request: NSMutableURLRequest){
        let header = buildRequestHeader()
        for (key, value) in header{
            request.setValue(value, forHTTPHeaderField: key)
        }
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

