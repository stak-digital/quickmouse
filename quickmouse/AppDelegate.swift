//
//  AppDelegate.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 3/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let keyCodeDict: Dictionary = [
        "NUMPAD_7": 89,
        "NUMPAD_8": 91,
        "NUMPAD_9": 92,
        "NUMPAD_4": 86,
        "NUMPAD_5": 87,
        "NUMPAD_6": 88,
        "NUMPAD_1": 83,
        "NUMPAD_2": 84,
        "NUMPAD_3": 85,
    ]
    
    var window: NSWindow!
    
    func myCallback(_ evt: NSEvent) {
        let keyCode = evt.keyCode
        
        if (Int(keyCode) == self.keyCodeDict["NUMPAD_7"]) {
            print("yeeeee")
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().background(Color.clear)
        //        let menubarHeight: Float = 20
        let screenSize = CGDisplayBounds(CGMainDisplayID())
        
        let fullScreenWindowRect = NSRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 20) // replace 20 with `menubarHeight`
        
        // Create the window and set the content view. 
        window = MyWindow(
            contentRect: fullScreenWindowRect,
            styleMask: [.fullSizeContentView, .titled],
            backing: .buffered,
            shouldDefer: false,
            keyDownHandler: myCallback
        )
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.isOpaque = false
        window.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0.1)
        window.setFrame(fullScreenWindowRect, display: true)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
