//
//  WZMusicHubController.swift
//  WZAuditory
//
//  Created by admin on 11/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit



class WZMusicHubController: UIViewController {
  
    var musicEntity : WZMusicEntity?
    
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    @IBOutlet weak var playModeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //WZMusicHub.share.isPlaying
        
        let bgColorView = UIView()
        bgColorView.frame = self.view.bounds
        bgColorView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.view.addSubview(bgColorView)
        self.view.sendSubview(toBack: bgColorView)
        
        //下一曲
        nextBtn .setImage(UIImage(named: "cm2_vehicle_btn_next") , for: .normal)
        nextBtn .setImage(UIImage(named: "cm2_vehicle_btn_next_prs") , for: .highlighted)
        //上一曲
        lastBtn .setImage(UIImage(named: "cm2_vehicle_btn_prev") , for: .normal)
        lastBtn .setImage(UIImage(named: "cm2_vehicle_btn_prev_prs") , for: .highlighted)
        
        //播放
        playBtn .setImage(UIImage(named: "cm2_vehicle_btn_play") , for: .normal)
        playBtn .setImage(UIImage(named: "cm2_vehicle_btn_play_prs") , for: .highlighted)
        //暂停
        playBtn .setImage(UIImage(named: "cm2_vehicle_btn_pause") , for: .selected)
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
    

    @IBAction func playModePick(_ sender: UIButton) {
    }
    
    @IBAction func last(_ sender: UIButton) {
    }
    
    
    @IBAction func playOrPause(_ sender: UIButton) {
        if WZMusicHub.share.isPlaying == false {
            WZMusicHub.share.play()
        } else {
            WZMusicHub.share.pause()
        }
        
    }
    
    
    @IBAction func next(_ sender: UIButton) {
    }
 
    @IBAction func showList(_ sender: UIButton) {
    }
    
}
