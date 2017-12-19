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
import MediaPlayer //锁屏控制

enum WZMusicPlayMode  {
    case random
    case one
    case loop
}



/// 播放监听者的协议
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


//MARK: - 单例模式 所有音乐的目录缓存器
final class WZMusicHub: NSObject {

    static let share = WZMusicHub()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(audioItemDidPlayToEndTime(notification :)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.audioConfigNotification()
        UIApplication.shared.beginReceivingRemoteControlEvents()
          self.configRemoteCommandCenter()
    }//外部不可访问
    
    deinit {
     
        NotificationCenter.default.removeObserver(self)
    }
    ///播放体数组
    var entityList : Array<WZMusicEntity> = Array<WZMusicEntity>()
    //正在播放或者是暂停的URL
    var playingURL : URL?
    ////是否要播放的是下一首歌
    var nextSong : Bool = false
    //当前播放音乐的角标
    var currentPlayingIndex : IndexPath?
    //监听者列表
    var observersList: Array<WZMusicHubProtocol> = Array<WZMusicHubProtocol>()
    //音乐播放器
    var player : AVPlayer?
    var itemDuration : CMTime?
    //判断是否正在播放
    var isPlaying = false
    //进度监听
    var progressObserve : Any?
    //播放模式。默认循环
    var playMode : WZMusicPlayMode = WZMusicPlayMode.loop
    var currentEntity : WZMusicEntity? {
        get {
            if currentPlayingIndex == nil {
                return nil
            } else {
                return entityList[currentPlayingIndex!.row]
            }
        }
    }
    
    ///监听者
    func appendObserver(element : WZMusicHubProtocol) -> Void {
        self.observersList.append(element)
    }
    ///移除某一个监听者
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
        self.classForCoder.cancelPreviousPerformRequests(withTarget: self)//去掉变换mode
        
        if entityList.count <= 0 {
            return;
            assert(false, "没数据")
        }
        
        if currentPlayingIndex == nil {
           //modeLoop
            currentPlayingIndex = IndexPath(row: 0, section: 0)
        }
        
        if player == nil {
            player = AVPlayer()
            progressObserve = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.5, 600) , queue: DispatchQueue.main, using: { (cmtime) in
                //处理时间回调
                print("时间:\(CMTimeGetSeconds(cmtime))")
                //                let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
                //                info[MPNowPlayingInfoPropertyPlaybackRate] =
            })
        }
        
        if nextSong == true {
            //上一首 下一首（更换item）
            let tmpIndexPath = currentPlayingIndex!
            let itmeURL : URL =  entityList[tmpIndexPath.row].bundlePath!
            let playerItem = AVPlayerItem(url: itmeURL)
//            print(playerItem.duration)//获取失败
//            print(AVAsset(url: itmeURL).duration)//获取成功
            itemDuration = AVAsset(url: itmeURL).duration
            player?.replaceCurrentItem(with: playerItem);
        } else {
            //暂停 播放
        }
        
        if player != nil {
            
            isPlaying = true
            nextSong = false
            
//            有影响播放的嫌疑
            if self.currentPlayingIndex != nil {
                for tmp in observersList {
                    tmp.play(currentIndex: self.currentPlayingIndex!)
                }
            }
            
            self.mediaItemArtwork()
          
            player!.play()
            self.configAudioBackMode()
        } else {
            assert(false, "状态错误")
            return
        }
    }
    
    
    
    @objc func playItem(_ command : MPRemoteCommand) -> Void {
        DispatchQueue.main.async {
           self.play()
        }
    }
    @objc func pauseItem(_ command : MPRemoteCommand) -> Void {
        DispatchQueue.main.async {
            self.pause()
        }
    }
    @objc func previousItem(_ command : MPRemoteCommand) -> Void {
        DispatchQueue.main.async {
           self.last()
        }
    }
    @objc func nextItem(_ command : MPRemoteCommand) -> Void {
        DispatchQueue.main.async {
            self.next()
        }
    }
    
    
    
    
    ///暂停
    func pause() {
        DispatchQueue.main.async {
           
            self.isPlaying = false
            if self.currentPlayingIndex != nil {
                for tmp in self.observersList {
                    tmp.pause(currentIndex: self.currentPlayingIndex!)
                }
            }
            self.player?.pause()
         
//            self.recoverAudioBackMode()
        }
        
//        self.classForCoder.cancelPreviousPerformRequests(withTarget: self)
//        self.perform(#selector(backMode(sender :)), with: self, afterDelay: 5);
       
    }
    
    @objc func backMode(sender : WZMusicHub) -> Void {
        self.recoverAudioBackMode()
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    }
    
    //MARK: - 媒体信息配置
    ///配置多媒体控制面板的显示页面
    func mediaItemArtwork() -> Void {
        DispatchQueue.main.async {
            let entity = self.currentEntity
            if entity != nil {
                ///设置后台播放时显示的东西，例如歌曲名字，图片等
                let image = UIImage(named: entity!.clear!)
                if image != nil {
                    var info : [String : Any] = Dictionary()
                    ///标题
                    info[MPMediaItemPropertyTitle] = entity!.bundlePath!.lastPathComponent
                    ///作者
                    info[MPMediaItemPropertyArtist] = "wizet"
                    ///封面
                    let artWork = MPMediaItemArtwork(boundsSize: image!.size, requestHandler: { (size) -> UIImage in return image! })
                    info[MPMediaItemPropertyArtwork] = artWork
                    if self.itemDuration != nil {
                        //当前播放进度 会被自动计算出来 暂停时使用到
                        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self.player!.currentTime()))
                        
                        //调整外部显示的播放速率正常为1、一般都是根据内部播放器的播放速率作同步，一般不必修改
                        //                        info[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1)
                        
                        //播放总时间
                        let duration = CMTimeGetSeconds(self.itemDuration!)
                        info[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: duration)
                    }
                    
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                    
                }
            }
        }
    }
    //MARK: - 远程控制配置
    ///配置远程控制显示的信息
    func configRemoteCommandCenter() -> Void {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        //播放事件
        let playCommand = remoteCommandCenter.playCommand
        playCommand.isEnabled = true
        playCommand.addTarget(self, action: #selector(playItem(_ : )))
        
        //暂停事件
        let pauseCommand = remoteCommandCenter.pauseCommand
        pauseCommand.isEnabled = true
        pauseCommand.addTarget(self, action: #selector(pauseItem(_ : )))
        
        //下一曲
        let nextTrackCommand = remoteCommandCenter.nextTrackCommand
        nextTrackCommand.isEnabled = true
        nextTrackCommand.addTarget(self, action: #selector(nextItem(_ : )))
        //上一曲
        let previousTrackCommand = remoteCommandCenter.previousTrackCommand
        previousTrackCommand.isEnabled = true
        previousTrackCommand.addTarget(self, action: #selector(previousItem(_ : )))
        
        //
        //        //耳机
        //        let togglePlayPauseCommand = remoteCommandCenter.togglePlayPauseCommand
        //        togglePlayPauseCommand.isEnabled = true
        //        togglePlayPauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //            //处理
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        
        //        //快进 快退
        //        let intervals : Int = 10
        //        let skipForwardCommand = remoteCommandCenter.skipForwardCommand
        //        skipForwardCommand.isEnabled = true
        //        skipForwardCommand.preferredIntervals = [NSNumber(value : intervals)]//显示在系统层面的数据
        //        skipForwardCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //            //根据自定义的数字进行seekTime达到快进快退效果
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        //        let skipBackwardCommand = remoteCommandCenter.skipBackwardCommand
        //        skipBackwardCommand.isEnabled = true
        //        skipBackwardCommand.preferredIntervals = [NSNumber(value : intervals)]
        //        skipBackwardCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        
        //        //更改播放速率
        //        let changePlaybackRateCommand = remoteCommandCenter.changePlaybackRateCommand
        //        changePlaybackRateCommand.isEnabled = true
        //        changePlaybackRateCommand.supportedPlaybackRates = [NSNumber(value : 2)]
        //        changePlaybackRateCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //            print(#function)
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        //
        //        //重复模式
        //        let changeRepeatModeCommand = remoteCommandCenter.changeRepeatModeCommand
        //        changeRepeatModeCommand.isEnabled = true
        //        changeRepeatModeCommand.currentRepeatType = MPRepeatType.all
        //        changeRepeatModeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //            print(#function)
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        ////        //耳机开关？
        //        let changeShuffleModeCommand = remoteCommandCenter.changeShuffleModeCommand
        //        changeShuffleModeCommand.isEnabled = true
        //        changeShuffleModeCommand.currentShuffleType = MPShuffleType.collections
        //        changeShuffleModeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //             print(#function)
        //
        //
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        //
        ////        //评分
        //        let ratingCommand = remoteCommandCenter.ratingCommand
        //        ratingCommand.isEnabled = true
        //        ratingCommand.maximumRating = 0.0
        //        ratingCommand.maximumRating = 10.0
        //        ratingCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //             print(#function)
        //            return MPRemoteCommandHandlerStatus.success
        //        }
        
        //反馈信息
        //            let likeCommand = remoteCommandCenter.likeCommand
        //            likeCommand.isEnabled = true
        //            likeCommand.isActive = true
        //            likeCommand.localizedTitle = "零零落落"
        //            likeCommand.localizedShortTitle = "温柔"
        //            likeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //
        //                return MPRemoteCommandHandlerStatus.success
        //            }
        //
        //            let dislikeCommand = remoteCommandCenter.dislikeCommand
        //            dislikeCommand.isEnabled = true
        //            dislikeCommand.isActive = true
        //            dislikeCommand.localizedTitle = "dislikeCommand"
        //            dislikeCommand.localizedShortTitle = "哈哈"
        //            dislikeCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //                return MPRemoteCommandHandlerStatus.success
        //            }
        //
        //            let bookmarkCommand = remoteCommandCenter.bookmarkCommand
        //            bookmarkCommand.isEnabled = true
        //            bookmarkCommand.isActive = true
        //            bookmarkCommand.localizedTitle = "bookmarkCommand"
        //            bookmarkCommand.localizedShortTitle = "吼猴"
        //            bookmarkCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
        //                return MPRemoteCommandHandlerStatus.success
        //            }
        
        //更改播放点位置
        let changePlaybackPositionCommand = remoteCommandCenter.changePlaybackPositionCommand
        changePlaybackPositionCommand.isEnabled = true
        changePlaybackPositionCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            //如何精确拖动的位置？
            let event = commandEvent as! MPChangePlaybackPositionCommandEvent
            
            if self.player != nil {
                //需要使用带回调的SeekTime 回调重新设置进度 否则播放进度条会停止
                self.player?.seek(to: CMTimeMakeWithSeconds(event.positionTime, 600), completionHandler: { (finish) in
                    //Q：拖动介绍后进度条不动了
                    //重新修改进度条
                    var dic = MPNowPlayingInfoCenter.default().nowPlayingInfo
                    dic?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(self.player!.currentTime()))
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
                })
                
                return MPRemoteCommandHandlerStatus.success
            } else {
                //更新位置
                return MPRemoteCommandHandlerStatus.commandFailed
            }
        }
        
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
            try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
            try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions())//取消混合和duck模式
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
            self.classForCoder.cancelPreviousPerformRequests(withTarget: self)//去掉变换mode
            
            let interruptionType = sender.userInfo?[AVAudioSessionInterruptionTypeKey] as! UInt
            if interruptionType == AVAudioSessionInterruptionType.began.rawValue {
                print("开始中断")
                //中断播放
                
                self.pause()
                let audioSession = AVAudioSession.sharedInstance()
                try? audioSession.setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                try? audioSession.setCategory(AVAudioSessionCategorySoloAmbient, with: AVAudioSessionCategoryOptions())//默认模式
               
                //处理UI 恢复状态
                self.classForCoder.cancelPreviousPerformRequests(withTarget: self)//去掉变换mode
            } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
                print("结束中断")
               
                let interruptOption = sender.userInfo?[AVAudioSessionInterruptionOptionKey] as! UInt
                if interruptOption == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                        let lock = NSLock()
                        lock.try()
                        //Step 1 设置为混合加duck模式
                        let audioSession = AVAudioSession.sharedInstance()
                        try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                        try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions(rawValue: AVAudioSessionCategoryOptions.RawValue(UInt8(AVAudioSessionCategoryOptions.mixWithOthers.rawValue)|UInt8(AVAudioSessionCategoryOptions.duckOthers.rawValue))))
                        
                        print(audioSession.categoryOptions)
                        while self.player!.timeControlStatus != .playing {
                            self.play()
                            print("死循环形式播放")
                        }
                        
                        try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                        try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions())
                        print(audioSession.categoryOptions)
                        //Step 2 播放音频
                        lock.unlock()
                    }
                    
                } else {
                    //恢复状态
                    print("can not resume")
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



//MARK: - 播放数据实体
class WZMusicEntity {
    var clear : String?
    var thunbmail : String?
    var bundlePath: URL?//本地bundle保存的路径
    var localPath : URL?//本地磁盘保存的路径
    var remoteURL : URL?//远程URL    
}
