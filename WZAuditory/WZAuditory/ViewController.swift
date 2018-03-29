//
//  ViewController.swift
//  WZAuditory
//
//  Created by admin on 5/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import MediaPlayer
import Alamofire


typealias CustomInt = Int

enum NickName : Int {
    case A = 1
    case B = 2
    case C = 3
    case D = 4
    case E = 5
}
/*吃饭协议*/

struct Wizet : Codable {
    let name : String?
    let age : UInt?
    
}

class Person : eatProtocol {
    
    //imp eatProtocol
    func eat() {
        print("吃饭")
    }
    
}
///对person进行扩展
extension Person {
//    var nickname : String?//Extensions may not contain stored properties  不能扩展计算存储，只能扩展存储属性
    func addTwo(one : Int , two : Int) -> Int {
        if one is Int {//类型检查
            
        }
        if two is Int {
            
        }
      
        
        
        return one+two;
    }
}

///

protocol eatProtocol {
    func eat() -> Void;
}

//只拓展给UIView类型的
extension eatProtocol where Self : UIView {
    func eatSth() -> Void {
        print("earSth")
    }
}

//class CustomView: UIView, eatProtocol {
//    func eat() {
//        print(self)
//        self.eatSth()
//    }
//}

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    var table : UITableView?
    var list : [Dictionary<String, AnyClass>]?
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.list = [["title": WZEnsembleController.classForCoder()]
                    , ["title": WZMusicRecycleController.classForCoder()]
                    ]
        self.creatViews()
     

    }
    
    deinit {
        print(#function);
    }
    
    
    ///单元测试
    func run() -> Void  {
        print("单元测试啊～～～")
    }
    
    func creatViews() -> Void {
        self.table = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(self.table!)
        self.table!.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.description())
        self.table!.delegate = self
        self.table!.dataSource = self

        
        //        ///http://api.seqier.com/api/bing/img_1366  图片URL
        //get请求
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
 
        var emptyArray = [String]()
        var emptyDictionary = Dictionary<String, Float>()

        //        逃逸闭包:当函数执行结束后,才去调用函数内部的闭包,叫做逃逸闭包 @escaping
        //        非逃逸闭包:当函数执行过程中,执行的函数内部的闭包,叫做非逃逸闭包 @noescape

        let decimalInteger = 17           // 17 - 十进制表示
        let binaryInteger = 0b10001       // 17 - 二进制表示
        let octalInteger = 0o21           // 17 - 八进制表示
        let hexadecimalInteger = 0x11     // 17 - 十六进制表示
        let decimalDouble = 12.1875       //十进制浮点型字面量
        let exponentDouble = 1.21875e1    //十进制浮点型字面量
        let hexadecimalDouble = 0xC.3p0   //十六进制浮点型字面量



        var arr = [1, 2,3, 4, 5]
        arr = arr.map { (varr) -> Int in
            return (varr * 10)
        }
        print(arr)
        
        arr = arr.filter { (varr) -> Bool in
            return (varr > 30)
        }
        print(arr)
        
        var arrSum = arr.reduce(0) { (sum, varr) -> Int in
             return (varr+sum);
        }
        
      
        print(arrSum)
      
        var valuetest = 1
        guard valuetest != 1  else {
            print("false false ~~~")
            return
        }
        
    }
    
  
    class CustomClass {
        
        static let name = "wizet"
        var name:String?
        
        static func call(name : String) -> String {
            return "hello!\(name)"
        }
        
        init() {
      
        }
        
        init(name : String) {
            self.name = name
        }
    }
    
    
    //MARK:  针对于safeArea在viewDidLoad为zero 目前的处理方式 重新布局
    ///目前的方法是在这里进行重布局操作
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.table?.snp.makeConstraints { (make) in
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaInsets.top)
                make.right.equalTo(self.view.safeAreaInsets.right)
                make.left.equalTo(self.view.safeAreaInsets.left)
                make.bottom.equalTo(-self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
        }
    }
    
    
    
    //MARK: - delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = table?.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.description())
        }
        
        cell?.textLabel?.text = self.list![indexPath.row]["title"]?.description()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let custumClass : AnyClass = self.list![indexPath.row]["title"]!
        guard  ((custumClass as? UIViewController.Type) != nil) else {
            return
        }
        
        self.navigationController?.pushViewController((custumClass as! UIViewController.Type).init(), animated: true)
    }
   
}

