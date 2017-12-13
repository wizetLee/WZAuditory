//
//  WZAudioFileStreamController.swift
//  WZAuditory
//
//  Created by admin on 12/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio
import CoreAudioKit

class WZAudioFileStreamController: UIViewController {

    private var selfInstance: UnsafeMutableRawPointer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 1、上下文对象
        /// 2、歌曲信息解析的回调、每解析出一个歌曲信息都会进行一次回调
        /// 3、分离帧的回调，每解析出一部分帧就会进行回调
        /// 4、是文件类型的提示，这个参数来帮助AudioFileStream对文件格式进行解析。(当文件信息存在缺陷时、可通过type做相应的处理)
        /// 5、返回的AudioFileStream实例对应的AudioFileStreamID，这个ID需要保存起来作为后续一些方法的参数使用
        /// 返回值用来判断是否成功初始化（OSStatus == noErr）。
        
        selfInstance = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        
//        let aaa : OSStatus = AudioFileStreamOpen(<#T##inClientData: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>, <#T##inPropertyListenerProc: AudioFileStream_PropertyListenerProc##AudioFileStream_PropertyListenerProc##(UnsafeMutableRawPointer, AudioFileStreamID, AudioFileStreamPropertyID, UnsafeMutablePointer<AudioFileStreamPropertyFlags>) -> Void#>, <#T##inPacketsProc: AudioFileStream_PacketsProc##AudioFileStream_PacketsProc##(UnsafeMutableRawPointer, UInt32, UInt32, UnsafeRawPointer, UnsafeMutablePointer<AudioStreamPacketDescription>) -> Void#>, <#T##inFileTypeHint: AudioFileTypeID##AudioFileTypeID#>, <#T##outAudioFileStream: UnsafeMutablePointer<AudioFileStreamID?>##UnsafeMutablePointer<AudioFileStreamID?>#>)
     
    }

}
