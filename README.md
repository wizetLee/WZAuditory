# WZAuditory
##目标：
        实现网易云音乐播放音乐时提供给锁屏的媒体资源信息以及控制中心中对音乐的控制。
        实现过程使用到的工具接口（MediaPlayer）
            1、MPNowPlayingInfoCenter
            2、MPRemoteCommandCenter

##MPNowPlayingInfoCenter：
######是什么：
		一个可用于设置并显示APP中当前播放的媒体信息的对象
######做什么：
		1、在设备锁屏界面和控制中心中(in the multimedia controls in the multitasking UI)显示媒体信息
		2、通过AirPlay将媒体资源在AppleTV中播放时，播放信息将会出现在电视屏幕上。
		3、当前设备连接到一个iPod附件上，附件上也会显示当前正在播放的媒体信息
######怎么做：（Demo有更详细的实现）
		1、直接使用MPNowPlayingInfoCenter提供的单例根据需求的键值配置nowPlayingInfo属性 。
		如：
			var info : [String : Any] = Dictionary()
			//作者
			info[MPMediaItemPropertyArtist] = "wizet"
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
 
######蹩脚英文翻译系列:（未标注版本的键均为iOS8及以下可用）
| Name |  Type | meaning |
| ------------- |:-------------:| -----:|
| MPMediaItemPropertyAlbumTitle     	      | NSString  	                            | 专辑歌曲数|
|MPMediaItemPropertyAlbumTrackCount     | NSNumber of NSUInteger   |专辑歌曲数| 			
|MPMediaItemPropertyAlbumTrackNumber   |NSNumber of NSUInteger	|艺术家/歌手|
|MPMediaItemPropertyArtist          |	NSString	|艺术家/歌手 |
|MPMediaItemPropertyArtwork            	|MPMediaItemArtwork	|封面图片 MPMediaItemArtwork类型|
|MPMediaItemPropertyComposer        | 	NSString	|作曲
|MPMediaItemPropertyDiscCount        | 	NSNumber of NSUInteger	|专辑数
|MPMediaItemPropertyDiscNumber       	NSNumber of NSUInteger	|专辑编号
|MPMediaItemPropertyGenre              |	NSString|	类型/流派
|MPMediaItemPropertyPersistentID      | NSNumber of uint64_t	|唯一标识符	
| MPMediaItemPropertyPlaybackDuration    |  NSNumber of NSTimeInterval	| 歌曲时长  NSNumber类型	
|MPMediaItemPropertyTitle    |NSString|歌曲名称
|MPNowPlayingInfoPropertyElapsedPlaybackTime	|NSNumber (double)|	在播资源的时间流逝，s为单位。流逝时间会从播放时间和播放速率中自动计算，不合适频繁得更新
|MPNowPlayingInfoPropertyPlaybackRate	|NSNumber (double)|	在播资源的速率（保持与APP内播放器的速率一致）|
|MPNowPlayingInfoPropertyDefaultPlaybackRate |	NSNumber (double)	|在播资源的“默认”播放速率，当你的APP需要播放资源的播放速率默认都是大于1的，那么就应该使用这属性
|MPNowPlayingInfoPropertyPlaybackQueueIndex	 |NSNumber (NSUInteger)	|应用重放队列中，当前播放项的索引。注意索引值从0开始
|MPNowPlayingInfoPropertyPlaybackQueueCount |NSNumber (NSUInteger)	|应用重放队列的总资源数目
|MPNowPlayingInfoPropertyChapterNumber	|NSNumber (NSUInteger)	|这在播放的部分，索引值从0开始
|MPNowPlayingInfoPropertyChapterCount	|NSNumber (NSUInteger)	|在播资源的总章节数目
|MPNowPlayingInfoPropertyIsLiveStream(iOS 10.0)	|NSNumber (BOOL)|	表示当前的资源是不是实时流
|MPNowPlayingInfoPropertyAvailableLanguageOptions(iOS 9.0)|	NSArrayRef of MPNowPlayingInfoLanguageOptionGroup|	在播资源的一组可用的语言类型。在给定组中一次只能播放一种语言类型的资源
|MPNowPlayingInfoPropertyCurrentLanguageOptions(iOS 9.0)	|NSArray of MPNowPlayingInfoLanguageOption	|当前播放项目的语言选项列表
|MPNowPlayingInfoCollectionIdentifier(iOS 9.3)	|NSString	|表示当前播放资源所归属的那个集合的标识符，可指作者、专辑、播放列表等。可用于请求重新播放这个集合。
|MPNowPlayingInfoPropertyExternalContentIdentifier(iOS 10.0)	|NSString|	一个不暴露的唯一标志符，标志当前正在播放的item，贯穿APP重启。可使用任何格式，仅用于引用这个item和返回到正在播放资源的APP中
|MPNowPlayingInfoPropertyExternalUserProfileIdentifier(iOS 10.0)|	NSString	|一个可选型的不暴露的标志，标志当前正在播放的资源的配置文件，贯穿APP重启。可使用任何格式，仅用于返回到这个配置文件对应的正在播放视频的APP
|MPNowPlayingInfoPropertyServiceIdentifier(iOS 11.0)|	NSString|	服务商的唯一标志。如果当前播放的资源属于一个频道或者是定于的服务类型，这个ID可以用于区分和协调特定服务商的多种资源类型
|MPNowPlayingInfoPropertyPlaybackProgress(iOS 10.0)|	NSNumber (float)	|表示当前播放资源的播放进度，0.0表示未开始，1.0表示完全浏览完。区分于ElapsedPlaybackTime，无需更高的精度要求。如：当字幕开始滚动时，这个电影可能被用户期望开始播放（由字幕驱动播放进度）      
|MPNowPlayingInfoPropertyMediaType	|NSNumber (MPNowPlayingInfoMediaType)	|指定当前媒体类型，用于确定系统显示的用户界面类型
|MPNowPlayingInfoPropertyAssetURL(iOS 10.3)	|NSURL	|指向当前正播放的视频或音频资源的URL。可将视频缩略图或者音频的波普图使用于系统的UI上
	
##远程控制：
####iOS7.1前使用的方法（remote control event）
		处理流程:（不建议使用）
			1、开启接收远程控制事件(- (void)beginReceivingRemoteControlEvents)
			2、配置相应的信息（图片，进度，下一首，上一首，或者自定义处理事件），以及对应事件的处理
				(- (void)remoteControlReceivedWithEvent:(UIEvent *)event)
			3、结束接收远程控制事件（释放前处理 - (void)endReceivingRemoteControlEvents)

例子：
    
        在APPDelegate中的didFinishLaunching中调用  UIApplication.shared.beginReceivingRemoteControlEvents()//开始接收远程控制
        并且重写接收远程控制信息的接口
        override func remoteControlReceived(with event: UIEvent?) {
            if event != nil {
                if event!.subtype == UIEventSubtype.remoteControlPlay {
                    WZMusicHub.share.play()
                } else if event!.subtype == UIEventSubtype.remoteControlPause {
                    WZMusicHub.share.pause()
                } else if event!.subtype == UIEventSubtype.remoteControlNextTrack {
                    WZMusicHub.share.next()
                } else if event!.subtype == UIEventSubtype.remoteControlPreviousTrack {
                    WZMusicHub.share.last()
                } else if event!.subtype == UIEventSubtype.remoteControlTogglePlayPause {
                    //耳机的播放暂停
                }
              }
          }

		
####iOS7.1后使用MPRemoteCommandCenter
######是什么：
        一个可响应系统外部附件（耳机等）以及系统控件发出的远程控制事件的对象。
######做什么：
        获取到这个单例对象后，使用共享的MPRemoteCommand对象，用于响应各种远程控制事件配置自己的需求。
        如：像网易云音乐一样，在锁屏以及多媒体系统UI界面配置滑动播放进度（seekTime），下一曲，上一曲，喜欢，不喜欢等配置
![](http://upload-images.jianshu.io/upload_images/1408682-1adbf888d4c0b411.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/1408682-03f781c8137ee75b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/1408682-6a5863b5f0a17787.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 ![](http://upload-images.jianshu.io/upload_images/1408682-88cfec8e98a1cb09.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######怎么做：（Demo有更详细的实现）
        一般的使用流程： 
            1、使用MPNowPlayingInfoCenter提供的单例，可获得若干个command对象
            2、需要使用到的command设置对应isEnable属性为true，即开启了对应系统控件的可使用权
              （部分command之间存在冲突，因为都位于同一位置，冲突的command部分UI最后显示的是最后开启的command）
            3、最后是进行command事件回调处理
        另外有个别的command由于类型的多样化，具有独立特性的（如：MPFeedbackComman等）需要额外配置特定的接口

##关于一些需求和实现过程的问题
        1、锁屏显示歌词的处理：浏览了一些想法，都是绘制歌词到图片处
                这个功能个人认为比较鸡肋，毕竟我觉得挺少人会面向锁屏去看歌词了😂，
                而且iOS11的锁屏UI还改了，图变得更小了，那么这个功能估计会被砍掉。
        2、使用changePlaybackPositionCommand进行seekTime时候，控制中心的播放进度条停止了下来
			使用带handler的回调，在回调处再次对info进行进度条的更新
        3、布局时UI的位置错误
          self.navigationController?.navigationBar.bounds.size.height ?? 0 + UIApplication.shared.statusBarFrame.size.height
          这个写法系统会把0 + UIApplication.shared.statusBarFrame.size.height归为一个整体，
          这就告诉了我们括号了重要性了🤣
           (self.navigationController?.navigationBar.bounds.size.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
##最后效果：
![](http://upload-images.jianshu.io/upload_images/1408682-5590bd4632677c0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/1408682-5e9f9260d290f083.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##[Demo地址](https://github.com/wizetLee/WZAuditory)
详细路径![](http://upload-images.jianshu.io/upload_images/1408682-5754b8592addc34f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

	
