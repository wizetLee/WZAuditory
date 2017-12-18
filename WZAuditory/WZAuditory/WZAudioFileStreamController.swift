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

class WZAudioFileStreamController: UIViewController {

    private var selfInstance: UnsafeMutableRawPointer? = nil
    var audioFileStreamID: AudioFileStreamID? = nil
    
    var discontinuous: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        let this = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        //属性回调
        let propertyCallback: AudioFileStream_PropertyListenerProc = {  userData, inAudioFileStream, propertyId, ioFlags in
            let sself = Unmanaged<WZAudioFileStreamController>.fromOpaque(userData).takeUnretainedValue()
            sself.propertyValueCallback(userData: userData,
                                        inAudioFileStream: inAudioFileStream,
                                        propertyId: propertyId,
                                        ioFlags: ioFlags)
        }
        ///包回调
        let callback: AudioFileStream_PacketsProc = { userData, inNumberBytes, inNumberPackets, inInputData, inPacketDescriptions in
            let sself = Unmanaged<WZAudioFileStreamController>.fromOpaque(userData).takeUnretainedValue()
            sself.streamDataCallback(inNumberBytes: inNumberBytes, inNumberPackets: inNumberPackets, inInputData: inInputData, inPacketDescriptions: inPacketDescriptions)
        }
        /// 1、上下文对象
        /// 2、歌曲信息解析的回调、每解析出一个歌曲信息都会进行一次回调
        /// 3、分离帧的回调，每解析出一部分帧就会进行回调
        /// 4、是文件类型的提示，这个参数来帮助AudioFileStream对文件格式进行解析。(当文件信息存在缺陷时、可通过type做相应的处理)
        /// 5、返回的AudioFileStream实例对应的AudioFileStreamID，这个ID需要保存起来作为后续一些方法的参数使用
        /// 返回值用来判断是否成功初始化（OSStatus == noErr）。
        let status : OSStatus = AudioFileStreamOpen(this
            , propertyCallback
            , callback
            , 0 ///不明确文件类型的传入0 
            , &audioFileStreamID)
        
        if status == noErr {
            //调整某些状态开始
        } else {
            assert(false, "出错啦")
        }
    
        
        let path = Bundle.main.path(forResource: "Ocean", ofType: "m4a")
        
        if path == nil {
            assert(false, "资源缺失")
        }
        
        let fileHandle : FileHandle = FileHandle(forReadingAtPath: path!)!;
        var fileSize : UInt64 = (try! FileManager.default.attributesOfItem(atPath: path!)[FileAttributeKey.size] as! UInt64)
        
        if fileSize > 0 {
            let lengthPreRead : Int = 10000//每次读取的数据
            let data = fileHandle.readData(ofLength: lengthPreRead);
            fileSize = fileSize - UInt64(data.count)
            
            
        }
        
        
        ///接收数据进行回调
        
        ///1、句柄
        ///2、本次解析的数据长度
        ///3、本次解析的数据
        ///4、本次的解析和上一次解析是否是连续的关系，如果是连续的传入0，否则传入kAudioFileStreamParseFlag_Discontinuity。
        /**
         PS: 注意要点
             “连续”。在第一篇中我们提到过形如MP3的数据都以帧的形式存在的，解析时也需要以帧为单位解析。但在解码之前我们不可能知道每个帧的边界在第几个字节，所以就会出现这样的情况：我们传给AudioFileStreamParseBytes的数据在解析完成之后会有一部分数据余下来，这部分数据是接下去那一帧的前半部分，如果再次有数据输入需要继续解析时就必须要用到前一次解析余下来的数据才能保证帧数据完整，所以在正常播放的情况下传入0即可。
             目前知道的需要传入kAudioFileStreamParseFlag_Discontinuity的情况有两个，一个是在seek完毕之后显然seek后的数据和之前的数据完全无关；另一个是开源播放器AudioStreamer的作者@Matt Gallagher曾在自己的blog中提到过的： Matt发布这篇blog是在2008年，这个Bug年代相当久远了，而且原因未知，究竟是否修复也不得而知，而且由于环境不同（比如测试用的mp3文件和所处的iOS系统）无法重现这个问题，所以我个人觉得还是按照Matt的work around在回调得到kAudioFileStreamProperty_ReadyToProducePackets之后，在正常解析第一帧之前都传入kAudioFileStreamParseFlag_Discontinuity比较好。
         */
        let isContinuous : Bool = true
        let inDataByteSize : UInt32 = 10
        var inData : UnsafeRawPointer?
        //开始解析数据
        let parseStatus : OSStatus = AudioFileStreamParseBytes(audioFileStreamID!
            , inDataByteSize
            , inData
            , (isContinuous ? AudioFileStreamParseFlags.init(rawValue: 0) : AudioFileStreamParseFlags.discontinuity))
        /// 如果要写入磁盘的话注意返回值类型
        if parseStatus == noErr {
            
        } else if parseStatus == kAudioFileStreamError_UnsupportedFileType {
            //分析解析错误的类型
        } else {
            assert(false, "解析出错啦");
        }
    }
    
    
    
    private func propertyValueCallback(userData: UnsafeMutableRawPointer, inAudioFileStream: AudioFileStreamID,
                                           propertyId: AudioFileStreamPropertyID, ioFlags: UnsafeMutablePointer<AudioFileStreamPropertyFlags>) {
    }
    
    // MARK: streamDataCallback
    private func streamDataCallback(inNumberBytes: UInt32, inNumberPackets: UInt32, inInputData: UnsafeRawPointer, inPacketDescriptions: UnsafeMutablePointer<AudioStreamPacketDescription>) {
        
    }
    

}
