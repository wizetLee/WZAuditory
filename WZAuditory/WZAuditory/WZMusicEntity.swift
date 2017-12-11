//
//  WZMusicEntity.swift
//  WZAuditory
//
//  Created by admin on 11/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import Foundation

//单例模式 所有音乐的目录缓存器
final class WZMusicHub: NSObject {
    var entityList : Array<WZMusicEntity> = Array<WZMusicEntity>()
    static let share = WZMusicHub()
    private override init() {}//外部不可访问
    var playingURL : URL?        //正在播放或者是暂停的URL
    var isPlaying : Bool = false //是否正在播放
}

class WZMusicEntity {
    var bundlePath: URL?//本地bundle保存的路径
    var localPath : URL?//本地磁盘保存的路径
    var remoteURL : URL?//远程URL
    var playing : Bool = false//正在播放？
    
}
