//
//  WZMusicRecycleController.swift
//  WZAuditory
//
//  Created by 李炜钊 on 2017/12/10.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

class WZMusicRecycleController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    var table : UITableView?
    var relaxList : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData()
        self.createViews()
    }

    func createViews()  {
        self.table = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(self.table!)
        self.table!.register(UINib.init(nibName: "WZMusicRecycleCell", bundle: Bundle.main), forCellReuseIdentifier: WZMusicRecycleCell.description())
        self.table!.delegate = self
        self.table!.dataSource = self
        
        
    }
    
    func configData() -> Void {
        self.relaxList = ["5Types",
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
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK: -Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.relaxList?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WZMusicRecycleCell = tableView.dequeueReusableCell(withIdentifier: WZMusicRecycleCell.description(), for: indexPath) as! WZMusicRecycleCell
        
        return cell
    }
    
}
