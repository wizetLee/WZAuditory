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

protocol WZMusicHubProtocol {
    func play(currentIndex : IndexPath);
    func pause(currentIndex : IndexPath);
    func next(nextIndex : IndexPath, currentIndex : IndexPath);
    func last(lastIndex : IndexPath, currentIndex : IndexPath);
}



//单例模式 所有音乐的目录缓存器
final class WZMusicHub: NSObject {
    var entityList : Array<WZMusicEntity> = Array<WZMusicEntity>()
    static let share = WZMusicHub()
    private override init() {}//外部不可访问
    var playingURL : URL?        //正在播放或者是暂停的URL
    var isPlaying : Bool = false //是否正在播放
    var currentPlayingIndex : IndexPath?
    
    var observersList: Array <WZMusicHubProtocol> = Array<WZMusicHubProtocol>()//监听者列表
    
    var player : AVPlayer?
    var progressObserve : Any?
    var playMode : WZMusicPlayMode = WZMusicPlayMode.loop
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
                //回到最初
                tmpIndexPAth = IndexPath(row: 0, section: 0)
            }
            
            ///loopLoop
            for tmp in observersList {
                tmp.next(nextIndex: tmpIndexPAth!, currentIndex: currentPlayingIndex!)
                currentPlayingIndex = tmpIndexPAth
            }
        }
    }
    
    ///上一曲
    func last()  {
        for tmp in observersList {
          
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
        
        if progressObserve != nil {
            player?.removeTimeObserver(progressObserve!)
            player = nil;
        }
        
        //重新初始化AVPlayer
        let tmpIndexPath = currentPlayingIndex!
        let itmeURL : URL =  entityList[tmpIndexPath.row].bundlePath!
        let playerItem = AVPlayerItem(url: itmeURL)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        progressObserve  = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.5, 600) , queue: DispatchQueue.main, using: { (cmtime) in
            //处理时间回调
            
        })
        
        switch playMode {
            case .loop:
                print("ssss")
          
            case .random:
                print("ssss")
            
            case .one:
                print("ssss")
        }
    
        
        if player != nil {
            
        } else {
            assert(false, "状态错误")
            return
        }
        
        for tmp in observersList {
            
        }
    }
    
    ///播放对应角标的文件
    func playAtIndex(IndexPath : IndexPath) {
        
    }
    
    ///暂停
    func pause() {
        player?.pause()
        for tmp in observersList {
         
        }
    }
    
}

class WZMusicEntity {
    var bundlePath: URL?//本地bundle保存的路径
    var localPath : URL?//本地磁盘保存的路径
    var remoteURL : URL?//远程URL
    var playing : Bool = false//正在播放？
    
}
