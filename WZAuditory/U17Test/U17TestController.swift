//
//  U17TestController.swift
//  WZAuditory
//
//  Created by 李炜钊 on 2018/3/30.
//  Copyright © 2018年 wizet. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol TestProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

struct MyStruct : TestProtocol {
   
    
    var simpleDescription: String = "wizet"
    mutating func adjust() {
        simpleDescription = "wizet2"
    }
    
    var color = UIColor.red
    
    
}

enum MyEnum : TestProtocol {
    case First, Second, Third
    
    var simpleDescription: String {
        get {
            switch self {
            case .First:
                return "first"
            case .Second:
                return "second"
            case .Third:
                return "third"
            }
        }
        set {
            simpleDescription = newValue
        }
    }
    
    func adjust() {
        
    }
    
    
}


class U17TestController: UIViewController, TestProtocol {

    var simpleDescription: String = "hahhaha"
    var anotherProperty: Int = 110
    
    func adjust() {
        simpleDescription = "～～～"
        anotherProperty = 101
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //        ///http://api.seqier.com/api/bing/img_1366  图片URL
        //默认是get请求。使用alamofire
        let dataR: DataRequest =  Alamofire.request(URL.init(string: "http://api.seqier.com/api/bing/img_1366")!)
        dataR.responseData { (response : DataResponse) in
            switch response.result{
            case .success(_):
                response.result.value as AnyObject?
                print(response.result.value ?? "response.result.value = nil");
            case .failure(_):
                response.result.error as NSError?
                print(response.result.error ?? "response.result.error = nil");
            }
        }
        
        //        逃逸闭包:当函数执行结束后,才去调用函数内部的闭包,叫做逃逸闭包 @escaping
        //        非逃逸闭包:当函数执行过程中,执行的函数内部的闭包,叫做非逃逸闭包 @noescape
        
        
        let addTwo = addTo(num: 2)//(Int) -> Int
        let add8 = addTwo(6)
        print(add8)
        
        
        var arr : Array<Any>?
        
    }
    
    func addTo(num : Int) -> (Int) -> Int {
        return {
            tmp in
            return (tmp + num)
        }
    }
   
}
