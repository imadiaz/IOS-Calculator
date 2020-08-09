//
//  AppDelegate.swift
//  IOS-Calculator
//
//  Created by Immanuel Díaz on 03/08/20.
//  Copyright © 2020 Immanuel Díaz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //set up
        setUpView()
        return true
    }

    //Mark -  private methos
    
    private func setUpView(){
        //Instance of the window var, the propety main.bounds get us the full screen weight and height
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }


}

