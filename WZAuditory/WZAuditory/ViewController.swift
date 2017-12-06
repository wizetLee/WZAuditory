//
//  ViewController.swift
//  WZAuditory
//
//  Created by admin on 5/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
   
    
    //MARK: Property
    var collection : UICollectionView?
    var ensemble : WZEnsemble = {return WZEnsemble()}()
    var urlList : Array<URL> = Array<URL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
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
        ///
        
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
        
        self.view.addSubview(self.collection!)
        self.collection?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        })
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
        cell.leftActionClosure = {
            weakSelf?.ensemble.appendAudioWithURL(url: self.urlList[indexPath.row])
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
            print("rightClosureAction")
            weakSelf?.ensemble.removeAudioWithURL(url: self.urlList[indexPath.row])
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


}

