//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Iberfan on 1/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var books = [AGTBook]()
        do{
            let json = try loadJSONFromURL()
            for dict in json{
                do{
                    let book = try decode(bookList: dict)
                    books.append(book)
                }catch{
                    fatalError("Error while processing JSON")
                }
            }
        }catch{
            fatalError("Error while loading JSON")
        }
        let model = AGTLibrary(withBooks: books)
        
        let libVC = LibraryViewControler(model: model)
        var img =  UIImage(named: "byTitle.png")
        
        libVC.tabBarItem = UITabBarItem(title: "Libros", image:img, tag: 1)
        let bkVC = BookViewController(model: model.books[0])
        //libVC.delegate=bkVC
        
        let tagVC = TagLibraryViewController(model : model)
        img =  UIImage(named: "byTag.png")
        tagVC.tabBarItem = UITabBarItem(title: "Tags", image: img, tag: 2)
        
        let tb = UITabBarController()
        
        tb.setViewControllers([libVC,tagVC], animated: true)
        tb.title = "Library"
        let uNav = UINavigationController(rootViewController: tb)
        
        
        window?.rootViewController=uNav
        
        // hacer visible & key a la window
        window?.makeKeyAndVisible()
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

