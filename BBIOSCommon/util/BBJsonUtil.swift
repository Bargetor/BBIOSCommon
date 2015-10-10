//
//  BBJsonUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/2/28.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import SwiftyJSON

public class BBJsonUtil: NSObject {
    
//    public class func jsonWithString(jsonData: String) -> NSDictionary{
//        var data: NSData = NSData(data: jsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
//        var err: NSError?
//        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
//        return jsonResult
//    }
    
//    public class func jsonWithNSData(data: NSData) -> JSON{
//        return JSON(data: data)
//    }
//    
//    
//    public class func jsonDataToNSObject(data: NSData, nsclass: AnyClass) -> AnyObject?{
//        let json = jsonWithNSData(data)
//        return jsonToNSObject(json, nsclass: nsclass)
//    }
//    
//    public class func jsonStrToNSObject(jsonStr: String, nsclass: AnyClass) -> AnyObject?{
//        let json = JSON(jsonStr)
//        return jsonToNSObject(json, nsclass: nsclass)
//    }
//    
//    public class func jsonToNSObject(json: JSON, nsclass: AnyClass) -> AnyObject{
//        var result = nsclass.new() as! NSObject
//        var keysAndType = BBReflectUtil.getNSObjextAllKeysAndTypes(nsclass)
//        
//        if keysAndType.count <= 0 {
//            return result
//        }
//        
//        for (key, type) in keysAndType{
//            let jsonValue = json[key]
//            if jsonValue == nil {
//                continue
//            }
//            
//            if BBReflectUtil.isBaseType(type){
//                result.setValue(getBaseValueFromJson(type, json: jsonValue), forKey: key)
//            }else if BBReflectUtil.isArray(type){
//                let arraySubType: AnyClass? = BBReflectUtil.getArrayGenerics(type)
//                if arraySubType == nil{
//                    continue
//                }
//                let subValue = jsonArrayToArray(jsonValue, subClass: arraySubType!)
//                result.setValue(subValue, forKey: key)
//            }
//        
//        }
//        
//        return result
//    }
//    
//    private class func jsonArrayToArray(json: JSON, subClass: AnyClass) -> Array<AnyObject>{
//        var result: Array<AnyObject> = Array()
//        for value in json.arrayValue{
//            if BBReflectUtil.isBaseType(subClass){
//                result.append(getBaseValueFromJson(subClass, json: value)!)
//            }else{
//                result.append(jsonToNSObject(json, nsclass: subClass))
//            }
//        }
//        
//        return result
//    }
//    
//    /**
//    * 从json中获取跟类型相匹配的值
//    **/
//    private class func getBaseValueFromJson(type: Any, json:JSON) -> AnyObject?{
//        let baseType = BBReflectUtil.whichBaseType(type)
//        switch baseType{
//        case .Bool:
//            return json.boolValue
//            
//        case .String:
//            return json.stringValue
//            
//        case .Int:
//            return json.intValue
//            
//        case .Float:
//            return json.floatValue
//            
//        case .Double:
//            return json.doubleValue
//            
//        case .Float:
//            return json.floatValue
//            
//        default:
//            return nil
//        }
//        
//        
//    }
}
