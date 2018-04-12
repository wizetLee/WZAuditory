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
                    , ["title": U17TestController.classForCoder()]
                    , ["title": ChainController.classForCoder()]
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

