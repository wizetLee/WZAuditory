//
//  WZToast.swift
//  WZLearnSwift
//
//  Created by 李炜钊 on 2017/9/2.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

enum WZToastPositionType  {
    case WZToastPositionTypeMiddle
    case WZToastPositionTypeTop
    case WZToastPositionTypeBottom
}

class WZToast: UIView {

    deinit {
        print("dealloc __ \(String(WZToast.description()))" )
    }
    
    static func toastWithContent(content : String) {
        self.toastWithContent(content: content, duration: 1.5)
    }
    
    static func toastWithContent(content : String,  duration : TimeInterval) {
        self.toastWithContent(content: content, position:.WZToastPositionTypeMiddle, duration: duration)
    }
    
    static func toastWithContent(content : String, position : WZToastPositionType, duration : TimeInterval) {
        self.toastWithContent(content: content, position: position, duration: duration, customOriginY: false, customOriginYMake: 0, customOrigin: false, customOriginMake: CGPoint())
    }
    
    static func toastWithContent(content : String, position : WZToastPositionType, duration : TimeInterval,  customOrigin : CGPoint) {
        self.toastWithContent(content: content, position: position, duration: duration, customOriginY: false, customOriginYMake: 0, customOrigin: true, customOriginMake: customOrigin)
    }
    
    static func toastWithContent(content : String,
                                 position : WZToastPositionType,
                                 duration : TimeInterval,
                                 customOriginY : Bool,
                                 customOriginYMake: CGFloat,
                                 customOrigin : Bool,
                                 customOriginMake : CGPoint
                                 ) {
        let toast : WZToast = WZToast()
        toast.alpha = 0.0
        toast.layer.cornerRadius = 10.0
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        if !content.isEmpty {//非空
            let label : UILabel = UILabel()
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            label.text = content
            label.textAlignment = .center
            label.numberOfLines = 0
            
            let window : UIWindow? = toast.getFrontWindow()
            if window == nil { return }
            
            toast.addSubview(label)
            window?.addSubview(toast)
            
            let labelLRSpacingSum : CGFloat = 30.0
            let labelTBSpacingSum : CGFloat = 30.0
            var labelH : CGFloat = label.sizeThatFits(CGSize()).height + 30
            var labelW : CGFloat = label.sizeThatFits(CGSize()).width
            let boundingSpacing : CGFloat = 40.0
            
            let toastRestrictW : CGFloat = UIScreen.main.bounds.width - boundingSpacing * 2.0
            
            if labelW > toastRestrictW {
                let calculatelabelW = toastRestrictW - labelLRSpacingSum;
                labelH = label.sizeThatFits(CGSize(width: calculatelabelW - labelLRSpacingSum, height: 0)).height + labelTBSpacingSum   - 4.0
                labelW = label.sizeThatFits(CGSize(width: calculatelabelW - labelLRSpacingSum, height: 0)).width
            }
 
            label.frame = CGRect(x: labelLRSpacingSum / 2.0, y: 0.0, width: labelW, height: labelH)
            
            let toastW = labelW + labelLRSpacingSum
            let toastH = labelH
            var toastX = (UIScreen.main.bounds.size.width - toastW) / 2.0
            var toastY = (UIScreen.main.bounds.size.height - toastH) / 2.0
            
            ///计算Y坐标
            switch position {
            case .WZToastPositionTypeTop :
                toastY = 100.0;
                break
            case .WZToastPositionTypeMiddle :
                break
            case .WZToastPositionTypeBottom :
                toastY = UIScreen.main.bounds.size.height - toastH - 100
                break
            }
            
            if customOriginY {
                toastY = customOriginYMake
            }
            
            if customOrigin {
                toastX = customOriginMake.x;
                toastY = customOriginMake.y;
            }
            
            toast.frame = CGRect(x: toastX, y: toastY, width: toastW, height: toastH)
            
            var tmpDuation = duration
            if tmpDuation < 0 || fabs(tmpDuation) < 0.00001 {
                tmpDuation = 0.80
            }
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                toast.alpha = 1.0
            }, completion: { (boolean) in
                UIView.animate(withDuration: tmpDuation, delay: 0.0, options: .allowUserInteraction, animations: {
                    toast.alpha = 0.0
                }, completion: { (boolean) in
                    toast.removeFromSuperview()
                })
            })
            
        }
    }
    
    func getFrontWindow() -> UIWindow? {
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        var window : UIWindow? = nil
        for tmpWindow in frontToBackWindows {
            let isWindowOnMainScreen : Bool = tmpWindow.screen == UIScreen.main
            let isWindowVisible : Bool = !tmpWindow.isHidden && tmpWindow.alpha > 0.001
            let isWindowNormalLevel : Bool = tmpWindow.windowLevel == UIWindowLevelNormal
            /*
             窗口的层级
             
             windowLevel: UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
             
             UIWindowLevelNormal : 默认窗口的层级
             
             UIWindowLevelStatusBar : 状态栏、键盘
             
             UIWindowLevelAlert :UIActionSheet,UIAlearView
             
             把window的层级设置为UIWindowLevelAlert ，就会显示在最前面
             
             相同层级的窗口，想让其中一个显示，可以用那个窗口的层级加上一个数
             */
            
            if isWindowOnMainScreen && isWindowVisible && isWindowNormalLevel {
                window = tmpWindow
                break;
            }
        }
        
        if window == nil {
            window = UIApplication.shared.windows.last
        }
        
        return window
    }

}
