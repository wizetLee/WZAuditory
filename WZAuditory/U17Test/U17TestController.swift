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



class U17TestController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
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
        
        
        
        
        
        
    }
    
}
