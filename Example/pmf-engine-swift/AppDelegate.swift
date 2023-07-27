//
//  AppDelegate.swift
//  pmf-engine-swift
//
//  Created by Nataliia on 07/25/2023.
//  Copyright (c) 2023 Nataliia. All rights reserved.
//

import UIKit
import pmf_engine_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    PMFEngine.default.configure(accountId: "yourAccountIdHere", userId: UUID().uuidString)
    showPMFPopupIfNeeded()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  private func showPMFPopupIfNeeded() {
    let popupView = PMFEnginePopupView()

    popupView.emoji = UIImage(named: "smilling-panda")
    popupView.title = "Pleeeeease! 🙏\n Help us to improve \nto help others!"
    popupView.subTitle = "By answering a few simple questions."
    popupView.confirmTitle = "Yes, happy to help!"
    popupView.cancelTitle = "No, I don’t want to help!"

    popupView.containerBackgroundColor = UIColor.white
    popupView.closeButtonTitleColor = UIColor.lightGray
    popupView.pmfButtonBackgroundColor = UIColor.purple
    popupView.pmfButtonTitleColor = UIColor.white

    popupView.confirmFont = UIFont.systemFont(
      ofSize: 17,
      weight: .bold
    )

    popupView.cancelFont = UIFont.systemFont(
      ofSize: 14,
      weight: .semibold
    )

    DispatchQueue.main.async {
      PMFEngine.default.forceShowPMFPopup(popupView: popupView, onViewController: self.window?.rootViewController?.topController)
    }
  }
}

