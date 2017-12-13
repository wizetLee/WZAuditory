//
//  WZMusicEntity.swift
//  WZAuditory
//
//  Created by admin on 11/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum WZMusicPlayMode  {
    case random
    case one
    case loop
}

protocol WZMusicHubProtocol : class {
    
    func play(currentIndex : IndexPath);
    func pause(currentIndex : IndexPath);
    func next(nextIndex : IndexPath, currentIndex : IndexPath);
    func last(lastIndex : IndexPath, currentIndex : IndexPath);
    func desc() -> String;//寻求替代的方法
}


////实现dexcription才能对比。。。。。
//func isEquals<T: Comparable>(a: T, b: T) -> Bool {
//    return (a == b)
//}


//单例模式 所有音乐的目录缓存器
final class WZMusicHub: NSObject {
    
    var entityList : Array<WZMusicEntity> = Array<WZMusicEntity>()
    static let share = WZMusicHub()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(audioItemDidPlayToEndTime(notification :)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.audioConfigNotification()
    }//外部不可访问
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var playingURL : URL?        //正在播放或者是暂停的URL
    var nextSong : Bool = false //是否正在播放
    var currentPlayingIndex : IndexPath?
    var observersList: Array<WZMusicHubProtocol> = Array<WZMusicHubProtocol>()//监听者列表
    var player : AVPlayer?
    var isPlaying = false
    var progressObserve : Any?
    var playMode : WZMusicPlayMode = WZMusicPlayMode.loop
    
    func appendObserver(element : WZMusicHubProtocol) -> Void {
        self.observersList.append(element)
    }
    
    func removeObserver(element : WZMusicHubProtocol) -> Void {
        var index : Int = -1;
        for (tmpIndex , value) in self.observersList.enumerated() {
            ///一个很菜的写法...
            if element.desc() == value.desc() {
                index = tmpIndex
                break
            }
        }
        if index >= 0 {
            self.observersList.remove(at: index)
        }
    }
   
    
    ///根据模式切换下一首歌
    @objc func audioItemDidPlayToEndTime(notification : Notification) {
        self.next()
    }
    
    ///下一曲
    func next() {
        //如果没有开始则直接在第一个音频开始播放
        if currentPlayingIndex == nil {
            assert(false, "跳入这个页面的时候currentPlayingIndex不可为nil")
        } else {
           
            var tmpIndexPAth : IndexPath?
            if (entityList.count > (currentPlayingIndex!.row + 1)) {
                tmpIndexPAth = IndexPath(row: currentPlayingIndex!.row + 1, section: 0)
            } else {
                tmpIndexPAth = IndexPath(row: 0, section: 0)
            }
            ///loopLoop
            let tmpCurrent : IndexPath = currentPlayingIndex!;
            currentPlayingIndex = tmpIndexPAth
            nextSong = true
            self.play()
           
            for tmp in observersList {
                tmp.next(nextIndex: currentPlayingIndex!, currentIndex: tmpCurrent)
            }
        }
    }
    
    ///上一曲
    func last()  {
        //如果没有开始则直接在第一个音频开始播放
        if currentPlayingIndex == nil || self.entityList.count <= 0 {
            assert(false, "跳入这个页面的时候currentPlayingIndex不可为nil")
        } else {
            var tmpIndexPAth : IndexPath?
            if (currentPlayingIndex!.row > 0) {
                tmpIndexPAth = IndexPath(row: currentPlayingIndex!.row - 1, section: 0)
            } else {
                tmpIndexPAth = IndexPath(row: self.entityList.count - 1, section: 0)
            }
            let tmpCurrent = currentPlayingIndex!;
            currentPlayingIndex = tmpIndexPAth
            nextSong = true
            self.play()
            
            ///loopLoop
            for tmp in observersList {
                tmp.last(lastIndex: currentPlayingIndex!, currentIndex: tmpCurrent)
            }
        }
    }
    
    ///播放
    func play() {
     
        if entityList.count <= 0 {
            assert(false, "没数据")
        }
        
        if currentPlayingIndex == nil {
           //modeLoop
            currentPlayingIndex = IndexPath(row: 0, section: 0)
        }
        
        if progressObserve != nil
            && nextSong == true {
            player?.removeTimeObserver(progressObserve!)
            player = nil;
        }
        
        if player == nil {
            //重新初始化AVPlayer
            let tmpIndexPath = currentPlayingIndex!
            let itmeURL : URL =  entityList[tmpIndexPath.row].bundlePath!
            let playerItem = AVPlayerItem(url: itmeURL)
            player = AVPlayer(playerItem: playerItem)
        }
        
        if player != nil {
           
            player?.play()
            self.configAudioBackMode()
            isPlaying = true
            nextSong = false
            progressObserve = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.5, 600) , queue: DispatchQueue.main, using: { (cmtime) in
                //处理时间回调
            })
           
        } else {
            assert(false, "状态错误")
            return
        }
    }
    
    ///暂停
    func pause() {
        player?.pause()
        isPlaying = false
        if self.currentPlayingIndex != nil {
            for tmp in observersList {
                tmp.pause(currentIndex: self.currentPlayingIndex!)
            }
        }
        self.recoverAudioBackMode()
    }
    
    
    //MARK: - 对于其他APP也有音频视频相关的一个比较好的处理方式
    ///恢复默认的后台播放模式
    func recoverAudioBackMode() {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category == AVAudioSessionCategorySoloAmbient {
            
        } else {
            try? audioSession.setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
            try? audioSession.setCategory(AVAudioSessionCategorySoloAmbient, with: AVAudioSessionCategoryOptions())//默认模式
        }
    }
    
    ///设置后台播放模式
    func configAudioBackMode() {
        //配置后台播放
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category == AVAudioSessionCategoryPlayback {
        } else {
            try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions())//取消混合和duck模式
            try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        }
    }
    
    func audioConfigNotification() {
        ///中断处理
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption(sender :)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        ///线路变更
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionRouteChange(sender :)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    @objc func audioSessionInterruption(sender : Notification) {
        DispatchQueue.main.async {
            let interruptionType = sender.userInfo?[AVAudioSessionInterruptionTypeKey] as! UInt
            if interruptionType == AVAudioSessionInterruptionType.began.rawValue {
                print("开始中断")
                //中断播放
                self.pause()
                //处理UI 恢复状态
                
            } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
                print("结束中断")
                let interruptOption = sender.userInfo?[AVAudioSessionInterruptionOptionKey] as! UInt
                if interruptOption == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                    
                    //Step 1 设置为混合加duck模式
                    let audioSession = AVAudioSession.sharedInstance()
                    try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                    try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions(rawValue: AVAudioSessionCategoryOptions.RawValue(UInt8(AVAudioSessionCategoryOptions.mixWithOthers.rawValue)|UInt8(AVAudioSessionCategoryOptions.duckOthers.rawValue))))
                    //Step 2 播放音频
                    self.play()
                    //第三部 恢复播放
                    try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions())//取消混合和duck模式
                    try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                    
                } else {
                    //恢复状态
                    print("can not resume")
                }
                
            }
        }
    }
    
    @objc func audioSessionRouteChange(sender : Notification) {
       
        DispatchQueue.main.async {
            let changeReason  = (sender.userInfo?[AVAudioSessionRouteChangeReasonKey]! as! Int)
            switch changeReason.hashValue {
            case AVAudioSessionRouteChangeReason.newDeviceAvailable.hashValue:
                print("AVAudioSessionRouteChangeReason.newDeviceAvailable")
                self.play()//拔出耳机 停止播放
                
            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
                print("AVAudioSessionRouteChangeReason.oldDeviceUnavailable")
                self.pause()//插入耳机 恢复播放
        
            default :
                print("未知， 未知")
            }
        }
    }
    
}

class WZMusicEntity {
    var bundlePath: URL?//本地bundle保存的路径
    var localPath : URL?//本地磁盘保存的路径
    var remoteURL : URL?//远程URL    
}
