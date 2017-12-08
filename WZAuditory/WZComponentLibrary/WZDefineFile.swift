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
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height

let isPhoneX : Bool = (STATUSBAR_HEIGHT > 20.0)
let isIPad : Bool = (UI_USER_INTERFACE_IDIOM() == .pad)
let currentVersion = UIDevice.current.systemVersion

//#define LocalString(x) NSLocalizedString(x,nil)

///获取国际化的字符串   Localizable
func getLocalString(str :String) -> String {
    return NSLocalizedString(str, comment: "Localizable");
}
