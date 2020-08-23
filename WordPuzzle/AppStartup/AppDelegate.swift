//
//  AppDelegate.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appCoordinator: AppCoordinator!
    static let container = Container()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Register Dependencies
        AppDelegate.container.registerDependencies()
        
        //Start App
        self.appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)!
        self.appCoordinator.start()
        return true
    }
}
