//
//  AppDelegate.swift
//  WZAuditory
//
//  Created by admin on 5/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if WZMusicHub.share.entityList.count > 0 {
//            UIApplication.shared.beginReceivingRemoteControlEvents()//远程控制
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        if WZMusicHub.share.entityList.count > 0 {
//            UIApplication.shared.beginReceivingRemoteControlEvents()//远程控制
//        }
    }

    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        if WZMusicHub.share.entityList.count > 0 {
//            UIApplication.shared.beginReceivingRemoteControlEvents()//远程控制
//        }
    }
    
    //远程控制
//    override func remoteControlReceived(with event: UIEvent?) {
//        if event != nil {
//            if event!.subtype == UIEventSubtype.remoteControlPlay {
//                WZMusicHub.share.play()
//            } else if event!.subtype == UIEventSubtype.remoteControlPause {
//                WZMusicHub.share.pause()
//            } else if event!.subtype == UIEventSubtype.remoteControlNextTrack {
//                WZMusicHub.share.next()
//            } else if event!.subtype == UIEventSubtype.remoteControlPreviousTrack {
//                WZMusicHub.share.last()
//            } else if event!.subtype == UIEventSubtype.remoteControlTogglePlayPause {
//                //耳机的播放暂停
//                print("未知类型")
//            }
//        }
//    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        UIApplication.shared.endReceivingRemoteControlEvents()//远程控制
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print(#function)
    }


}

