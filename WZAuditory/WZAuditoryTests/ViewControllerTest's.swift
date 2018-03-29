//
//  ViewControllerTest's.swift
//  WZAuditoryTests
//
//  Created by 李炜钊 on 2018/3/29.
//  Copyright © 2018年 wizet. All rights reserved.
//

import XCTest
@testable import WZAuditory

class ViewControllerTests: XCTestCase {
    
    var vc : ViewController?
    
    //一般做资源初始化工作
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = ViewController()
    }
   //一般做资源释放工作
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        vc = nil;
    }
    
    ///测试样例
    func testVCRun() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        vc?.run()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
