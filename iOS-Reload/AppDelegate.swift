//
//  AppDelegate.swift
//  iOS-Reload
//
//  Created by Matthew Li on 2018-03-08.
//  Copyright © 2018 matthewli. All rights reserved.
//

import UIKit

let ASSET_ID_NEO = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
let ASSET_ID_GAS = "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"

func assetNameFrom(id: String) -> String {
    var ret = id
    if id == ASSET_ID_NEO {
        ret = "NEO"
    } else if ret == ASSET_ID_GAS {
        ret = "GAS"
    }
    return ret
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    var runningWallets = [RunningWallet(nodeUrl: "http://52.170.21.212:10332", walletAddress: "Ac6V1vK3bQmpbzDEfpZRxAXWa38W5ugEFb"),
                          RunningWallet(nodeUrl: "http://13.92.154.220:10332", walletAddress: "ARAmW5NLwLzaStroAMGwDKebLB15vsTyR2"),
                          RunningWallet(nodeUrl: "http://52.224.237.18:10332", walletAddress: "AHMHSLmoLhhtn9t3XiqKxFFgpxAnqGzLgE"),
                          RunningWallet(nodeUrl: "http://52.168.31.148:10332", walletAddress: "AQF14KeouahBSiY1YuXX7KuNb5hh1Zosmz")]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

