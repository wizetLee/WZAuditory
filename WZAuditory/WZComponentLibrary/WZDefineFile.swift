//
//  WZDefineFile.swift
//  WZLearnSwift
//
//  Created by 李炜钊 on 2017/9/2.
//  Copyright © 2017年 wizet. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 常量区
let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height

let statusBar_height = UIApplication.shared.statusBarFrame.height

let isPhoneX : Bool = (statusBar_height > 20.0)
let isIPad : Bool = (UI_USER_INTERFACE_IDIOM() == .pad)
let currentVersion = UIDevice.current.systemVersion

//#define LocalString(x) NSLocalizedString(x,nil)

///获取国际化的字符串   Localizable
func getLocalString(str :String) -> String {
    return NSLocalizedString(str, comment: "Localizable");
}


///全局获取当前控制器的变量
var curVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)//应用对应的KW的根控制器
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)//选择弹出的控制器
    }
    return resultVC
}

///选出当前的控制器
private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)//栈尾的控制器
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)//tabar选中的控制器
    } else {
        return vc  //要不就是普通的控制器或者是nil
    }
}
