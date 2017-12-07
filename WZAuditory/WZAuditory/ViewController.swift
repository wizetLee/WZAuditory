//
//  ViewController.swift
//  WZAuditory
//
//  Created by admin on 5/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
   
    //MARK: Property
    var collection : UICollectionView?
    var ensemble : WZEnsemble = {return WZEnsemble()}()
    var urlList : Array<URL> = Array<URL>()
    var controlBar : WZAudioControlBar?
    
    
 
    deinit {
        self.recoverAudioBackMode()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioConfigNotification()
      
       
        let relaxList = ["5Types",
                         "AsianDuet",
                         "AsianPrayer",
                         "Bamboo",
                         "Beep",
                         "Bhakti",
                         "BucketDrops",
                         "CalmLake",
                         "Champagne",
                         "CherryBlossom",
                         "Chimes",
                         "Chinatown",
                         "ChineseFlute",
                         "Concentration",
                         "CrackingShip",
                         "Duck",
                         "ElectronicAlarm",
                         "FieldWind",
                         "ForestBirds",
                         "Frogs",
                         "GrandFatherClock",
                         "Harp",
                         "HealingWaves",
                         "ITConcentration20Hz",
                         "ITDreamlessSleep2.5Hz",
                         "ITRelaxation10Hz",
                         "Japanese",
                         "Journey",
                         "Lament",
                         "MeditationBowl",
                         "OldBell",
                         "Pizzicato",
                         "Progressive",
                         "Relaxation",
                         "Rooster",
                         "ScienceFiction",
                         "SeaBirds",
                         "SecretPearls",
                         "SilkRoute",
                         "Spaceship",
                         "StormWaves",
                         "Sushibar",
                         "Taiko",
                         "ThirdEye",
                         "Thunderstorm",
                         "TibetMountains",
                         ]
        for name in relaxList {
            let url = Bundle.main.url(forResource: name, withExtension: "caf")
            self.urlList.append(url!)
        }
        
        self.creatViews()
    }
    
    func creatViews() -> Void {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let gap : CGFloat = 2.0
        let wh = (UIScreen.main.bounds.size.width - 5 * gap) / 3.0
        layout.itemSize = CGSize.init(width: wh, height: wh)
        layout.sectionInset = UIEdgeInsetsMake(0.0, gap, 0.0, gap)
        layout.minimumLineSpacing = gap
        layout.minimumInteritemSpacing = gap
        
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collection!.delegate = self
        self.collection!.dataSource = self
//        self.collection!.register(WZEnsembleCell.classForCoder(), forCellWithReuseIdentifier: WZEnsembleCell.description())
        self.collection!.register(UINib.init(nibName: "WZEnsembleCell", bundle: Bundle.main), forCellWithReuseIdentifier: WZEnsembleCell.description())
        self.controlBar = Bundle.main.loadNibNamed("WZAudioControlBar", owner:nil, options: nil)?.first as? WZAudioControlBar
        
        weak var weakSelf = self
        
        self.controlBar?.clearActionClosure = {
            weakSelf?.ensemble.clear()
            weakSelf?.recoverAudioBackMode()
        }
        
        self.controlBar?.showVolumnControlActionClosure = {
            //处理系统级别的声音
        }
        
        self.controlBar?.playPauseActionClosure = {
            if weakSelf != nil {
                var isPlaying = false
                if weakSelf != nil
                    && weakSelf!.ensemble.audioMenu.count > 0 {
                    if(weakSelf?.ensemble.audioMenu.values.first)!.isPlaying {
                        isPlaying = true
                    }
                }
                if isPlaying {
                    weakSelf?.recoverAudioBackMode()
                    weakSelf?.ensemble.pause()
                    
                } else {
                    weakSelf?.configAudioBackMode()
                    weakSelf?.ensemble.play()
                    
                }
            }
        }
        
        self.view.addSubview(self.controlBar!)
        self.view.addSubview(self.collection!)
    }
    
    //MARK:  针对于safeArea在viewDidLoad为zero 目前的处理方式 重新布局
    ///目前的方法是在这里进行重布局操作
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.controlBar!.snp.makeConstraints { (make) in
            make.height.equalTo(44.0)
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaInsets.left)
                make.right.equalTo(self.view.safeAreaInsets.right)
                make.bottom.equalTo(-self.view.safeAreaInsets.bottom)
            } else {
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        self.collection?.snp.makeConstraints { (make) in
            make.bottom.equalTo((self.controlBar?.snp.top)!)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaInsets.top)
                make.right.equalTo(self.view.safeAreaInsets.right)
                make.left.equalTo(self.view.safeAreaInsets.left)
            } else {
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : WZEnsembleCell = collectionView.dequeueReusableCell(withReuseIdentifier: WZEnsembleCell.description(), for: indexPath) as! WZEnsembleCell
        //根据URL的映射得到图片
//        cell.imageView =
        cell.backgroundColor = UIColor.orange;
        cell.headlineLabel.text = self.urlList[indexPath.row].lastPathComponent
        weak var weakSelf = self
       
        cell.setIsPlaying(boolean: self.ensemble.audioMenu[self.urlList[indexPath.row]] != nil)
        cell.setVolumn(volumn: CGFloat(self.ensemble.audioMenu[self.urlList[indexPath.row]]?.volume ?? Float(self.ensemble.normalVolumn)))
        
        cell.tapActionClosure = {
            
            let inside = (weakSelf != nil && weakSelf!.urlList.count > indexPath.row && weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]] != nil)
            if inside {
                weakSelf!.ensemble.removeAudioWithURL(url: (weakSelf?.urlList[indexPath.row])!)
                cell.setIsPlaying(boolean: false)
                cell.setVolumn(volumn: CGFloat(weakSelf!.ensemble.normalVolumn))
                
               
                if weakSelf?.ensemble.audioMenu.count == 0 {
                     ///当前没有音频在播放需要切换回默认的类型
                    weakSelf?.recoverAudioBackMode()
                }
            } else {
                
                if AVAudioSession.sharedInstance().category != AVAudioSessionCategoryPlayback {
                        ///如果当前session的category非“理想类型”的时候需要切换
                        weakSelf?.configAudioBackMode()
                } else {
                    
                }

                weakSelf?.ensemble.appendAudioWithURL(url: (weakSelf?.urlList[indexPath.row])!)
                cell.setIsPlaying(boolean: true)
            }
        }
        
        cell.leftActionClosure = {
            let inside = (weakSelf != nil && weakSelf!.urlList.count > indexPath.row && weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]] != nil)
            if inside {
                var volumn = weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]]!.volume - 0.1
                if volumn < 0 { volumn = 0.0 }
                weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]]!.volume = volumn
                cell.setVolumn(volumn: CGFloat(volumn))
            }
            //约束更新
//            UIView.animate(withDuration: 4, animations: {
//                weakSelf?.collection?.snp.remakeConstraints({ (make) in
//                    make.left.equalTo(100)
//                    make.right.equalTo(-100)
//                    make.top.equalTo(100)
//                    make.bottom.equalTo(-100)
//                })
//                self.view.layoutIfNeeded()//动态更新约束 需要重新检查约束 需要使用这个方法
//            });
            
        }
        
        cell.rightActionClosure = {
            let inside = (weakSelf != nil && weakSelf!.urlList.count > indexPath.row && weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]] != nil)
            if inside {
                var volumn = weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]]!.volume + 0.1
                if volumn > 1 { volumn = 1.0 }
                weakSelf!.ensemble.audioMenu[weakSelf!.urlList[indexPath.row]]!.volume = volumn
                cell.setVolumn(volumn: CGFloat(volumn))
            }
        }
        return cell
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        //更新约束
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.collection?.snp.makeConstraints({ (make) in
//
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.right.equalToSuperview()
//        })
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - 对于其他APP也有音频视频相关的一个比较好的处理方式
    ///恢复默认的后台播放模式
    func recoverAudioBackMode() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategorySoloAmbient)//默认模式
        try? audioSession.setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
    }
    
    ///设置后台播放模式
    func configAudioBackMode() {
        //配置后台播放
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
        /* MixWithOthers is only valid with AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and  AVAudioSessionCategoryMultiRoute */
        //        public static var mixWithOthers: AVAudioSessionCategoryOptions { get }
        
        /* DuckOthers is only valid with AVAudioSessionCategoryAmbient, AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute */
        //       public static var duckOthers: AVAudioSessionCategoryOptions { get }
        
        /* AllowBluetooth is only valid with AVAudioSessionCategoryRecord and AVAudioSessionCategoryPlayAndRecord */
        //      public static var allowBluetooth: AVAudioSessionCategoryOptions { get }
        
        /* DefaultToSpeaker is only valid with AVAudioSessionCategoryPlayAndRecord */
        //      public static var defaultToSpeaker: AVAudioSessionCategoryOptions { get }
        
        /* InterruptSpokenAudioAndMixWithOthers is only valid with AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute */
        //      @available(iOS 9.0, *)
        //      public static var interruptSpokenAudioAndMixWithOthers: AVAudioSessionCategoryOptions { get }
        
        /* AllowBluetoothA2DP is only valid with AVAudioSessionCategoryPlayAndRecord */
        //    @available(iOS 10.0, *)
        //     public static var allowBluetoothA2DP: AVAudioSessionCategoryOptions { get }
        
        /* AllowAirPlay is only valid with AVAudioSessionCategoryPlayAndRecord */
        //     @available(iOS 10.0, *)
        //      public static var allowAirPlay: AVAudioSessionCategoryOptions { get }
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
                self.ensemble.pause()
                
            } else if interruptionType == AVAudioSessionInterruptionType.ended.rawValue {
                print("结束中断")
                let interruptOption = sender.userInfo?[AVAudioSessionInterruptionOptionKey] as! UInt
                if interruptOption == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                    
                    
//Step 1 设置为混合加duck模式
                    //终于可以恢复播放了 这算是一个终极大招了....🤣
                    let audioSession = AVAudioSession.sharedInstance()
                    try? audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                    try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions(rawValue: AVAudioSessionCategoryOptions.RawValue(UInt8(AVAudioSessionCategoryOptions.mixWithOthers.rawValue)|UInt8(AVAudioSessionCategoryOptions.duckOthers.rawValue))))
                    
                    /*
                     code 560557684  AVAudioSessionErrorCodeCannotInterruptOthers   一位别的应用在使用audio
                     */
//Step 2 播放音频
                    self.ensemble.play()
//Step 3 切换回AVAudioSessionCategoryPlayback模式
                    self.configAudioBackMode()//又把模式调回去AVAudioSessionCategoryPlayback
                    print("resumed")
                } else {
                    print("can not resume")
                }
            }
        }
    }
    
    @objc func audioSessionRouteChange(sender : Notification) {
        /* values for AVAudioSessionRouteChangeReasonKey in AVAudioSessionRouteChangeNotification userInfo dictionary
         1~~~~AVAudioSessionRouteChangeReasonUnknown
         The reason is unknown.
         2~~~~AVAudioSessionRouteChangeReasonNewDeviceAvailable
         A new device became available (e.g. headphones have been plugged in).
         3~~~~AVAudioSessionRouteChangeReasonOldDeviceUnavailable
         The old device became unavailable (e.g. headphones have been unplugged).
         4~~~~AVAudioSessionRouteChangeReasonCategoryChange
         The audio category has changed (e.g. AVAudioSessionCategoryPlayback has been changed to AVAudioSessionCategoryPlayAndRecord).
         5~~~~AVAudioSessionRouteChangeReasonOverride
         The route has been overridden (e.g. category is AVAudioSessionCategoryPlayAndRecord and the output
         has been changed from the receiver, which is the default, to the speaker).
         6~~~~AVAudioSessionRouteChangeReasonWakeFromSleep
         The device woke from sleep.
         7~~~~AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory
         Returned when there is no route for the current category (for instance, the category is AVAudioSessionCategoryRecord
         but no input device is available).
         8~~~~AVAudioSessionRouteChangeReasonRouteConfigurationChange
         Indicates that the set of input and/our output ports has not changed, but some aspect of their
         configuration has changed.  For example, a port's selected data source has changed.
         */
        DispatchQueue.main.async {
            let changeReason  = (sender.userInfo?[AVAudioSessionRouteChangeReasonKey]! as! Int)
            switch changeReason.hashValue {
            case AVAudioSessionRouteChangeReason.unknown.hashValue:
                print("AVAudioSessionRouteChangeReason.unknown")
                
            case AVAudioSessionRouteChangeReason.newDeviceAvailable.hashValue:
                print("AVAudioSessionRouteChangeReason.newDeviceAvailable")
                self.ensemble.play()//拔出耳机 停止播放
                
            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
                print("AVAudioSessionRouteChangeReason.oldDeviceUnavailable")
                self.ensemble.pause()//插入耳机 恢复播放
                
            case AVAudioSessionRouteChangeReason.categoryChange.hashValue:
                print("AVAudioSessionRouteChangeReason.categoryChange")
                
            case AVAudioSessionRouteChangeReason.override.hashValue:
                print("AVAudioSessionRouteChangeReason.override")
                
            case AVAudioSessionRouteChangeReason.wakeFromSleep.hashValue:
                print("AVAudioSessionRouteChangeReason.wakeFromSleep")
                
            case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory.hashValue:
                print("AVAudioSessionRouteChangeReason.noSuitableRouteForCategory")
                
            case AVAudioSessionRouteChangeReason.routeConfigurationChange.hashValue:
                print("AVAudioSessionRouteChangeReason.routeConfigurationChange")
            default :
                print("未知， 未知")
            }
        }
    }
}

