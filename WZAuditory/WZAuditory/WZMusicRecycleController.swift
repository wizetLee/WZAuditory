//
//  WZMusicRecycleController.swift
//  WZAuditory
//
//  Created by 李炜钊 on 2017/12/10.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit
import SnapKit

class WZMusicRecycleController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    var table : UITableView?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.configData()
        self.createViews()
    }

    func createViews()  {
        self.table = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(self.table!)
        self.table!.register(UINib.init(nibName: "WZMusicRecycleCell", bundle: Bundle.main), forCellReuseIdentifier: WZMusicRecycleCell.description())
        self.table!.delegate = self
        self.table!.dataSource = self
        self.table!.estimatedRowHeight = UITableViewAutomaticDimension
        self.table!.estimatedSectionFooterHeight = 0.0
        self.table!.estimatedSectionHeaderHeight = 0.0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.table?.snp.makeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    func configData() -> Void {
    let relaxList : Array<String> = ["5Types",
                                      "AsianDuet",
                                      "AsianPrayer",
                                      "Bamboo",
                                      "Beep",
                                      "BucketDrops",
                                      "CalmLake",
                                      "Champagne",
                                      "CherryBlossom",
                                      "Chimes",
                                      "Chinatown",
                                      "ChineseFlute",
                                      "Cicadas",
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
                                      "TraditionalAsian",
                                      "TropicalRain",
                                      "WaitingForWinter",
                                      "Waterfall",
                                      "WaterPrayers",
                                      "WaveSplashes",
                                      "WhaleCry",
                                      "WoodChimes",
                                      "Xylophone",
                                      "Yangtze",
                                      ]
        
        for tmpStr in relaxList {
            let entity : WZMusicEntity = WZMusicEntity()
            entity.bundlePath = Bundle.main.url(forResource: tmpStr, withExtension: "caf")
            WZMusicHub.share.entityList.append(entity)
        }
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WZMusicHub.share.entityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WZMusicRecycleCell = tableView.dequeueReusableCell(withIdentifier: WZMusicRecycleCell.description(), for: indexPath) as! WZMusicRecycleCell
        if WZMusicHub.share.entityList.count > indexPath.row {
            if WZMusicHub.share.entityList[indexPath.row].bundlePath != nil {
                let tmpEntity = WZMusicHub.share.entityList[indexPath.row];
                cell.titleLabel.text = tmpEntity.bundlePath?.lastPathComponent
                cell.titleLabel.textColor = tmpEntity.playing ? UIColor.red : UIColor.black
                cell.subtitleLabel.textColor = cell.titleLabel.textColor
            } else {
                cell.titleLabel.textColor = UIColor.black
                cell.subtitleLabel.textColor = UIColor.black
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpEntity = WZMusicHub.share.entityList[indexPath.row];
        
        if tmpEntity.playing == true {
            self.intoMusicHub()
            return
        }
        
        if WZMusicHub.share.currentPlayingIndex != nil {
            let lastIndexPath = WZMusicHub.share.currentPlayingIndex!;
            WZMusicHub.share.entityList[lastIndexPath.row].playing = false;
            WZMusicHub.share.entityList[indexPath.row].playing = true;
            //通知到那边
//            tableView.reloadRows(at: [indexPath, lastIndexPath], with: UITableViewRowAnimation.none)
            tableView.reloadData()
            WZMusicHub.share.currentPlayingIndex = indexPath;
        } else {
            WZMusicHub.share.currentPlayingIndex = indexPath;
             WZMusicHub.share.entityList[indexPath.row].playing = true;
//            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            tableView.reloadData()
        }
        self.intoMusicHub()
    }
    
    func intoMusicHub() -> Void {
        let vc : WZMusicHubController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WZMusicHubController") as! WZMusicHubController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
