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
    var isPlaying : Bool = false
    var volumeLayer : CALayer?
    var volumeMaskLayer : CALayer?
    var imageShade : CALayer?
    
    var leftActionClosure : (() -> Void)?
    var rightActionClosure : (() -> Void)?
    var tapActionClosure : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gap : CGFloat = 2.0
        let wh = (UIScreen.main.bounds.size.width - 5 * gap) / 3.0
        
        self.volumeLayer = CALayer()
        self.volumeMaskLayer = CALayer()
        self.volumeLayer!.frame = CGRect(x: 0.0, y: 0.0, width: wh, height: 5.0)
        self.volumeMaskLayer!.frame = CGRect(x: 0.0, y: 0.0, width: wh, height: 5.0)
        self.contentView.layer.addSublayer(self.volumeLayer!)
        self.contentView.layer.addSublayer(self.volumeMaskLayer!)
        self.volumeLayer!.backgroundColor = UIColor.gray.cgColor
        self.volumeMaskLayer!.backgroundColor = UIColor.white.cgColor
        
        self.imageShade = CALayer()
        self.imageShade!.frame = CGRect(x: 0, y: 0, width: wh, height: wh)
        self.imageView.backgroundColor = UIColor.yellow
        self.imageView.layer.addSublayer(self.imageShade!)
        self.imageShade?.backgroundColor = UIColor.black.withAlphaComponent(0.35).cgColor
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender :)))
        self.imageView.addGestureRecognizer(tap)
        
        self.setIsPlaying(boolean: self.isPlaying)
    }
    
    
    func setVolumn(volumn : CGFloat) -> Void {
        self.volumeMaskLayer!.frame = CGRect(x: self.volumeMaskLayer!.frame.origin.x, y: self.volumeMaskLayer!.frame.origin.y, width: self.volumeLayer!.frame.size.width * volumn, height: self.volumeMaskLayer!.frame.size.height)
    }
    
    func setIsPlaying(boolean : Bool) -> Void {
        self.isPlaying = boolean
        self.leftButton.isHidden = !boolean
        self.rightButton.isHidden = !boolean
        self.volumeMaskLayer!.isHidden = !boolean
        self.volumeLayer!.isHidden = !boolean
        self.imageShade!.isHidden = !boolean
    }
 
    @objc func tap(sender: UITapGestureRecognizer) {
        //取反
        tapActionClosure?()
    }
    
    @IBAction func leftAction(_ sender: UIButton) {
        self.leftActionClosure?()
    }
    @IBAction func rightAction(_ sender: UIButton) {
        self.rightActionClosure?()
    }
}
