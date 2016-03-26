//
//  AppDelegate.swift
//  sidemenu-example
//
//  Created by Artyom Devyatov on 26/03/16.
//  Copyright © 2016 Artyom Devyatov. All rights reserved.
//

import UIKit
import ARTSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    private func rootViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contentController = storyboard.instantiateViewControllerWithIdentifier("ContentNavigationController")
        let menuController = UITableViewController()
        let sideMenuController = ARTSideMenuController(contentController: contentController, menuController: menuController)

        return sideMenuController
    }

}

