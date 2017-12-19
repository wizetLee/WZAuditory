//
//  WZEnsembleVolumeAlert.swift
//  WZAuditory
//
//  Created by admin on 8/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import MediaPlayer

class WZEnsembleVolumeAlert: WZBaseAlert {
    
    let slider = UISlider()
    var volumeView : MPVolumeView?
    
    override func alertContent() {
        self.observeVolume()
        
        self.clickedBackgroundToDismiss = true
        
        let gap : CGFloat = 20.0
        var _ : CGFloat = 0.0
        var y : CGFloat = SCREEN_HEIGHT - 44.0
        let width : CGFloat = SCREEN_WIDTH - gap * 2
//        var height : CGFloat = SCREEN_HEIGHT - 44.0
        if #available(iOS 11.0, *) {
            y = y - self.safeAreaInsets.bottom
        }
        
        slider.frame = CGRect(x: gap, y: y, width: width, height: 44.0)
        self.addSubview(self.slider)
        
        //只能激活才能拿到当前系统的正确的声音 但是激活会导致别的正在播放的APP的暂停
        UIApplication.shared.beginReceivingRemoteControlEvents()
        slider.value = AVAudioSession.sharedInstance().outputVolume
        slider.addTarget(self, action: #selector(slider(sender:)), for: .allEvents)
        
        self.volumeView = WZEnsemble.getSystemVolumeView()
        self.addSubview(self.volumeView!)
       
    }
    
    @objc func slider(sender : UISlider) {
       
        WZEnsemble.slideSystemVolumne(volumneView: self.volumeView!, volumne: sender.value)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - 监听系统声音
    
    ///监听代理
    func observeVolume() {
        NotificationCenter.default.addObserver(self, selector: #selector(systemVolumeDidChangeNotification(sender:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc func systemVolumeDidChangeNotification(sender : Notification) {
        if let volum:Float = sender.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as! Float?{
            self.slider.value = volum
        }
    }
}
