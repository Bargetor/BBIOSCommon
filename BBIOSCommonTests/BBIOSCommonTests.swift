//
//  BBIOSCommonTests.swift
//  BBIOSCommonTests
//
//  Created by Bargetor on 15/5/23.
//  Copyright (c) 2015年 BesideBamboo. All rights reserved.
//

import UIKit
import XCTest

class BBIOSCommonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
//    func testHTTPRequest(){
//        BBHTTPHelper.get("http://www.baidu.com", params: nil, headers: nil, success: {(response: HTTPResponse) in
//            if let data = response.responseObject as? NSData {
//                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("response: \(str)") //prints the HTML of the page
//            }
//            },failure: {(error: NSError, response: HTTPResponse?) in
//                println("error: \(error)")
//        })
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
