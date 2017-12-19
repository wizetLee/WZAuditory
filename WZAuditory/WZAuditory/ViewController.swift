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
       
    }
    
    func creatViews() -> Void {
        self.table = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(self.table!)
        self.table!.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.description())
        self.table!.delegate = self
        self.table!.dataSource = self
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

