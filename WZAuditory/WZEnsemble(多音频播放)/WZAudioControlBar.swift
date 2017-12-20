//
//  WZAudioControlBar.swift
//  WZAuditory
//
//  Created by admin on 7/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

class WZAudioControlBar: UIView {

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumnButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var clearActionClosure : (() -> ())?
    var showVolumnControlActionClosure : (() -> ())?
    var playPauseActionClosure : (() -> ())?
    
    override func awakeFromNib() {
        
    }

    ///在播的全部清除
    @IBAction func clearAction(_ sender: UIButton) {
        self.clearActionClosure?()
    }
    
    ///显示音量控制
    @IBAction func showVolumnControlAction(_ sender: UIButton) {
        self.showVolumnControlActionClosure?()
    }
    
    ///暂停 播放
    @IBAction func playPauseAction(_ sender: UIButton) {
        self.playPauseActionClosure?()
    }
}
