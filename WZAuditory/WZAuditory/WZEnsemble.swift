//
//  WZEnsemble.swift
//  WZAuditory
//
//  Created by admin on 6/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import Foundation
import AVFoundation

///多重奏 用于播放本地的音频对象
class WZEnsemble {
    ///音频列表
    lazy var audioMenu : Dictionary<URL , AVAudioPlayer> = {return Dictionary<URL , AVAudioPlayer>() }();
    
    /// 添加音频
    /// - Parameter url: 本地音频地址
    func appendAudioWithURL(url : URL) -> Void {
        //本地的音频
        if  FileManager.default.fileExists(atPath: url.path) {
            
            if self.audioMenu[url] != nil {
                print("已添加")
            } else {
                let audio : AVAudioPlayer = try! AVAudioPlayer(contentsOf: url)
                audio.volume = 0.5;//默认值
                audio.prepareToPlay()
                audio.play()
                audio.numberOfLoops = -1
                self.audioMenu[url] = audio;
            }
        } else {
            assert(false, "添加失败,资源缺失~~~")
            print("添加失败,资源缺失~~~");
        }
    }
    
    /// 移除音频
    /// - Parameter url: 本地音频地址
    func removeAudioWithURL(url : URL) -> Void {
        if  FileManager.default.fileExists(atPath: url.path) {
            if self.audioMenu[url] != nil {
                self.audioMenu[url]?.pause()
                self.audioMenu.removeValue(forKey: url);
            }
        }
    }
    
    //声道 pan [-1, 1] [极左, 极右]
    //音量 volume
    //播放率 0.8~2.0
    //numberOfLoops  -1实现无缝循环
}
