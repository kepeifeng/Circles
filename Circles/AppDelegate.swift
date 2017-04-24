//
//  AppDelegate.swift
//  Circles
//
//  Created by Kent Peifeng Ke on 2017/4/16.
//  Copyright © 2017年 Kent Peifeng Ke. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        let vc = MainViewController()
        window.contentViewController = MainViewController()
        window.contentViewController?.view.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

