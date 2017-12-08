//
//  WZBaseAlert.swift
//  WZLearnSwift
//
//  Created by 李炜钊 on 2017/9/2.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

enum WZAlertDisplayDismissType {
    case gleamingly
    case fromBottomToTop
    case fromTopToBottom
}


class WZBaseAlert: UIView {

    var displayType : WZAlertDisplayDismissType = .gleamingly
    weak var forefrontWindow : UIWindow? = nil
    var clickedBackgroundToDismiss : Bool = false
    
    lazy var bgView : UIView  = {
        var view : UIView = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = self.bgViewColor()
        return view
    }()
    
    lazy var bgAnimationView : UIView  = {
        var view : UIView = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender :)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    @objc func tap(sender : UITapGestureRecognizer) {
        if clickedBackgroundToDismiss {
            self.alertDismiss(animation: true);
        }
    }
    
// MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(displayType : WZAlertDisplayDismissType) {
        super.init(frame : UIScreen.main.bounds)
        self.displayType = displayType;
    }
    
    // MARK: - Private Method
    deinit {
        print("deinit")
    }
    
    ///view即将出现
    func viewWillDisplay() {
        
        self.backgroundColor = UIColor.clear
        self.frame = UIScreen.main.bounds
        
        forefrontWindow = self.getFrontWindow()
        if forefrontWindow != nil {
            forefrontWindow?.addSubview(self)
            self.addSubview(self.bgView)
            self.addSubview(self.bgAnimationView)
            
            self.alertContent()
            self.viewStatusBeforeAnimat()
            self.animat()
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
    
    func viewStatusBeforeAnimat() {
        bgView.alpha = 0.0;
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        switch displayType {
        case .gleamingly:
            bgAnimationView.frame = UIScreen.main.bounds
            bgAnimationView.alpha = 0.0;
            break
        case .fromBottomToTop:
            bgAnimationView.frame = CGRect(x:0.0, y: -screenH, width: screenW, height: screenH)
            break
        case .fromTopToBottom:
            bgAnimationView.frame = CGRect(x:0.0, y: +screenH, width: screenW, height: screenH)
            break
        }
    }
    
    func animat() {
        UIView.animate(withDuration: self.beginAnimatDuration(), delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
            switch self.displayType {
            case .gleamingly:
                self.bgAnimationView.alpha = 1.0;
                break
            case .fromBottomToTop , .fromTopToBottom:
                self.bgAnimationView.frame = UIScreen.main.bounds
                break
            }
            self.bgView.alpha = self.bgViewAlpha()
        }) { (finished) in
            
        }
    }
    
    func removeAllView() {
        for view in self.bgView.subviews {
            view.removeFromSuperview()
        }
        for view in self.bgAnimationView.subviews {
            view.removeFromSuperview()
        }
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if view != self.bgView  && view != self.bgAnimationView {
            if !self.bgAnimationView.subviews.contains(view) {
                self.bgAnimationView.addSubview(view)
            } else {
                if !self.subviews.contains(view) {
                    self.addSubview(view)
                }
            }
        }
    }
    
    ///public
    ///开始动画时间
    func beginAnimatDuration() -> TimeInterval {
        return 1.25
    }
    
    func endAnimatDuration() -> TimeInterval {
        return 0.55
    }
    
    func bgViewColor() -> UIColor {
        return UIColor.black.withAlphaComponent(0.25)
    }
    
   
    func bgViewAlpha() -> CGFloat {
        return 1.0
    }
    
    
   // MARK: - Public Method
    func alertContent() {}
    
    func alertShow() {
        self.viewWillDisplay()
    }
    
    func alertDismiss(animation : Bool) {
        if animation {
            let screenW = UIScreen.main.bounds.size.width
            let screenH = UIScreen.main.bounds.size.height
            UIView.animate(withDuration: self.endAnimatDuration(), animations: {
                switch self.displayType {
                case .gleamingly:
                    self.bgAnimationView.alpha = 0.0;
                    break
                case .fromBottomToTop:
                    self.bgAnimationView.frame = CGRect(x:0.0, y: -screenH, width: screenW, height: screenH)
                    break
                    
                case .fromTopToBottom:
                    self.bgAnimationView.frame = CGRect(x:0.0, y: +screenH, width: screenW, height: screenH)
                    break
                }
                self.bgView.alpha = 0.0;
            }, completion: { (finished : Bool) in
                self.removeAllView()
            })
        }
    }
}
