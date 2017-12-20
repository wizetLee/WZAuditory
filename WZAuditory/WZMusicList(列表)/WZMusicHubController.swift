//
//  WZMusicHubController.swift
//  WZAuditory
//
//  Created by admin on 11/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

class WZMusicHubController: UIViewController, WZMusicHubProtocol {

    var musicEntity : WZMusicEntity?
    
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    @IBOutlet weak var playModeBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    
    deinit {
        print(self.description + " : " + #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let bgColorView = UIView()
        bgColorView.frame = self.view.bounds
        bgColorView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.view.addSubview(bgColorView)
        self.view.sendSubview(toBack: bgColorView)

        WZMusicHub.share.appendObserver(element: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(back(sender:)))
       
        //配置图片
        self.configImage()
        //根据数据配置UI
        self.updateView()
    }
    
    ///配置图片
    func configImage() -> Void {
        playModeBtn.isHidden = true
        listBtn.isHidden = true
        //下一曲
        nextBtn .setImage(UIImage(named: "cm2_vehicle_btn_next") , for: .normal)
        nextBtn .setImage(UIImage(named: "cm2_vehicle_btn_next_prs") , for: .highlighted)
        //上一曲
        lastBtn .setImage(UIImage(named: "cm2_vehicle_btn_prev") , for: .normal)
        lastBtn .setImage(UIImage(named: "cm2_vehicle_btn_prev_prs") , for: .highlighted)
        
        playBtn .setImage(UIImage(named: "cm2_vehicle_btn_pause") , for: .normal)
        playBtn .setImage(UIImage(named: "cm2_vehicle_btn_pause_prs") , for: .highlighted)
        
        //播放列表
        listBtn .setImage(UIImage(named: "cm2_play_btn_src"), for: .normal)
        listBtn .setImage(UIImage(named: "cm2_play_btn_src_prs"), for: .highlighted)
        
        //循环
        playModeBtn .setImage(UIImage(named: "cm2_play_btn_shuffle"), for: .normal)
        playModeBtn .setImage(UIImage(named: "cm2_play_btn_shuffle_prs"), for: .highlighted)
        
        //随机
        //        listBtn .setImage(UIImage(named: "cm2_play_btn_loop") , for: .normal)
        //        listBtn .setImage(UIImage(named: "cm2_play_btn_loop_prs") , for: .highlighted)
        //单曲
        //        listBtn .setImage(UIImage(named: "cm2_play_btn_one") , for: .normal)
        //        listBtn .setImage(UIImage(named: "cm2_play_btn_one_prs") , for: .highlighted)
    }
    
    ///回到上一个控制器
    @objc func back(sender : UIBarButtonItem) {
        //MARK: - 寻求非手动移除监控的办法
        WZMusicHub.share.removeObserver(element: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    ///播放模式。单曲 循环 顺序
    @IBAction func playModePick(_ sender: UIButton) {
    }
    
     ///上一曲
    @IBAction func last(_ sender: UIButton) {
        WZMusicHub.share.last()
    }
    
    ///播放 暂停
    @IBAction func playOrPause(_ sender: UIButton) {
        if WZMusicHub.share.player != nil
            && WZMusicHub.share.player!.timeControlStatus == .playing {
            WZMusicHub.share.pause()
        } else {
            WZMusicHub.share.play()
        }
    }
    
    ///下一首
    @IBAction func next(_ sender: UIButton) {
        WZMusicHub.share.next()
    }
    
    ///显示播放列表
    @IBAction func showList(_ sender: UIButton) {
    }
    
    //更新UI
    func updateView() -> Void {
         self.coverImageView.image = UIImage(named: WZMusicHub.share.currentEntity!.clear!)
        if WZMusicHub.share.isPlaying == true {
            //暂停
            playBtn .setImage(UIImage(named: "cm2_vehicle_btn_pause") , for: .normal)
            playBtn .setImage(UIImage(named: "cm2_vehicle_btn_pause_prs") , for: .highlighted)
        } else {
            //播放
            playBtn .setImage(UIImage(named: "cm2_vehicle_btn_play") , for: .normal)
            playBtn .setImage(UIImage(named: "cm2_vehicle_btn_play_prs") , for: .highlighted)
        }
    }
    
    //MARK: - 代理
    func play(currentIndex: IndexPath) {
        self.updateView()
    }
    
    func pause(currentIndex: IndexPath) {
        self.updateView()
    }
    
    func next(nextIndex: IndexPath, currentIndex: IndexPath) {
        //        self.updateView()
    }
    
    func last(lastIndex: IndexPath, currentIndex: IndexPath) {
        //        self.updateView()
    }
    
    func desc() -> String {
        return self.description
    }
}
