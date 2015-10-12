//
//  BBReflectUtil.swift
//  BBIOSCommon
//
//  Created by Bargetor on 15/5/24.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import Foundation

public enum BBBaseType :Int{
    
    case Double
    case String
    case Bool
    case Float
    case Int
    case Null
    case Unknown
}

public class BBReflectUtil{
    
    private static let IS_ARRAY_REGEX = RegexHelper("^(Swift\\.Optional<)?Swift\\.Array<[\\w\\.]+[>]*$")
    private static let IS_OPTIONAL_ARRAY_REGEX = RegexHelper("^(Swift\\.Optional<)Swift\\.Array<[\\w\\.]+[>]*$")
    private static let GET_OPTIONAL_ARRAY_GENERICS_TYPE_REGEX = RegexHelper("(?<=(Swift\\.Optional)<(Swift\\.Array)<)[\\w\\.]+(?=(>)*)")
    private static let GET_ARRAY_GENERICS_TYPE_REGEX = RegexHelper("(?<=(Swift\\.Array)<)[\\w\\.]+(?=(>)*)")
//    private static let GET_ARRAY_GENERICS_TYPE_REGEX = RegexHelper("(?<=(Swift\\.Optional<)?Swift\\.Array<)[\\w\\.]+(?=(<)*)")
    
    public class func getType<T>(x: T) -> Any.Type {
        let mir = getMirror(x)
        return mir.subjectType
    }
    
    public class func getMirror<T>(x: T) -> Mirror{
        let mir = Mirror(reflecting: x)
        return mir
    }
    
    public class func getClassName<T>(x: T) -> String{
        let mir = getMirror(x)
        return String(mir.subjectType)
    }
    
    /**
    * 判断nso是否有该选择器（属性、函数等）
    **/
    public class func checkNSOHasSelector(nso: NSObject, key: String) -> Bool{
        return nso.respondsToSelector(NSSelectorFromString(key))
    }
    
    /**
    * 获取父类
    **/
    public class func getSuperClass(x: AnyClass) -> Any.Type?{
        let mir = getMirror(x)
        if let superClassMir = mir.superclassMirror(){
            return superClassMir.subjectType
        }
        return nil
    }
    
    public class func isBaseType(x: Any) -> Bool{
        print("the is base type is :", terminator: "")
        print(x)
        let type = whichBaseType(x)
        if type == .Unknown{
            return false
        }else{
            return true
        }
    }
    
    public class func whichBaseType(x: Any) -> BBBaseType{
        
        if (x is Bool.Type) || (x is Optional<Bool>.Type){
            return .Bool
        }
        if (x is String.Type) || (x is Optional<String>.Type){
            return .String
        }
        if (x is Double.Type) || (x is Optional<Double>.Type){
            return .Double
        }
        if (x is Float.Type) || (x is Optional<Float>.Type){
            return .Float
        }
        if (x is Int.Type) || (x is Optional<Int>.Type){
            return .Int
        }
        return .Unknown
    }
    
    public class func isArray(x: Any) -> Bool{
        let mir = getMirror(x)

        //这里的实现很不优雅，使用字符串匹配实现
        if (IS_ARRAY_REGEX.match(mir.description)){
            return true
        }
        return false
    }
    
    public class func isOptionalArray(x: Any) -> Bool{
        let mir = getMirror(x)
        
        //这里的实现很不优雅，使用字符串匹配实现
        if (IS_OPTIONAL_ARRAY_REGEX.match(mir.description)){
            return true
        }
        return false
    }
    
    public class func getArrayGenerics(x: Any) -> AnyClass?{
        if !isArray(x){
            return nil
        }
        let mir = getMirror(x)
        
//        var generics: Array<String>
//        if isOptionalArray(x){
//            generics = GET_OPTIONAL_ARRAY_GENERICS_TYPE_REGEX.find(mir.summary)
//        }else{
//            generics = GET_ARRAY_GENERICS_TYPE_REGEX.find(mir.summary)
//        }
        
        var generics = GET_ARRAY_GENERICS_TYPE_REGEX.find(mir.description)
        print(generics)
        
        if generics.count > 1 || generics.count <= 0 {
            return nil
        }
        print(swiftClassFromString(generics[0]))
        
        return NSClassFromString(generics[0])
    }
    
    /**
    * 判断获取NSObject的所有key和类型，包括父类（父类也必须是NSObject）
    **/
//    public class func getNSObjextAllKeysAndTypes(x: AnyClass) -> Dictionary<String, Any.Type>{
//        var result: Dictionary<String, Any.Type> = getNSObjectKeysAndTypes(x)
//        let superClass: AnyClass? = getSuperClass(x)
//        if superClass == nil{
//            return result
//        }
//        if !isNSObject(superClass!){
//            return result
//        }else{
//            let superResult = getNSObjextAllKeysAndTypes(superClass!)
//            
//            for (key, value) in superResult{
//                result[key] = value
//            }
//            
//            return result
//        }
//        
//    }
    
    /**
    * 判断获取NSObject的所有key和类型，不包括父类（父类也必须是NSObject）
    **/
//    public class func getNSObjectKeysAndTypes(x: AnyClass) -> Dictionary<String, Any.Type>{
//        var result: Dictionary<String, Any.Type> = Dictionary<String, Any.Type>()
//        if !isNSObject(x) {
//            return result
//        }
//        let mir = getMirror(x)
//        if mir.count <= 0 {
//            return result
//        }
//        for i: Int in 0...(mir.count - 1){
//            let (name, subref) = mir[i]
//            if name == "super"{
//                continue
//            }
//            result[name] = subref.valueType
//        }
//        return result
//    }
    
    public class func isNSObject(x: Any) -> Bool{
        let mir = getMirror(x)
        return false
    }
    
    public class func isNSObject(clazz: AnyClass) -> Bool{
        return clazz.isSubclassOfClass(NSObject)
    }
    
    class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String! {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "_TtC\(appName.characters.count)\(appName)\(className.characters.count)\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
