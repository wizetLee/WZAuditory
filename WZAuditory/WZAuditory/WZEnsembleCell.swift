//
//  WZEnsembleCell.swift
//  WZAuditory
//
//  Created by admin on 6/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

class WZEnsembleCell: UICollectionViewCell {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    var volumeLayer : CALayer?
    var volumeMaskLayer : CALayer?
    
    
    var leftActionClosure : (() -> Void)?
    var rightActionClosure : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.volumeLayer = CALayer()
        self.volumeMaskLayer = CALayer()
        self.volumeLayer?.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 3.0)
        self.volumeMaskLayer?.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 3.0)
        self.contentView.layer.addSublayer(self.volumeLayer!)
        self.contentView.layer.addSublayer(self.volumeMaskLayer!)
        self.volumeLayer?.backgroundColor = UIColor.gray.cgColor
        self.volumeMaskLayer?.backgroundColor = UIColor.white.cgColor
        
        self.leftButton.isHidden = true
        self.rightButton.isHidden = true
        self.volumeMaskLayer?.isHidden = true
        self.volumeLayer?.isHidden = true
    }

    @IBAction func leftAction(_ sender: UIButton) {
        self.leftActionClosure?()
    }
    @IBAction func rightAction(_ sender: UIButton) {
        self.rightActionClosure?()
    }
}
