//
//  AppDelegate.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/17.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import Firebase
import LineSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            
        //Firebase
        FirebaseApp.configure()
        
        //LINEログイン
        LoginManager.shared.setup(channelID: "1655107304", universalLinkURL: nil)
        
        return true
    }
    //LINEログイン(iOS 12以前)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }

//iOS 13以降では、UISceneDelegateオブジェクトを呼び出して、URLを開きます。
//    // SceneDelegate.swiftに記述
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        _ = LoginManager.shared.application(.shared, open: URLContexts.first?.url)
//    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

