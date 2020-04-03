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
        "NUMPAD_ENTER": 76,
        "RETURN": 36
    ]
    
    var window: NSWindow!
    
    
    func myCallback(_ evt: NSEvent) {
        
        let keyCode = Int(evt.keyCode)
        let currentSize = self.window.frame.size
        let frame = self.window.frame
                
        var rect: NSRect;
        
        let newWidth = currentSize.width / 3
        let newHeight = currentSize.height / 3
        
        switch keyCode {
        case self.keyCodeDict["NUMPAD_7"]:
            rect = NSRect(x: frame.minX, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
            break
        case self.keyCodeDict["NUMPAD_8"]:
            rect = NSRect(x: frame.minX + newWidth, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
            break
        case self.keyCodeDict["NUMPAD_9"]:
            rect = NSRect(x: frame.minX + newWidth * 2, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_4"]:
            rect = NSRect(x: frame.minX, y: frame.minY + newHeight, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_5"]:
            rect = NSRect(x: frame.minX + newWidth, y: frame.minY + newHeight, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_6"]:
            rect = NSRect(x: frame.minX + newWidth * 2, y: frame.minY + newHeight, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_1"]:
            rect = NSRect(x: frame.minX, y: frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_2"]:
            rect = NSRect(x: frame.minX + newWidth, y: frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["NUMPAD_3"]:
            rect = NSRect(x: frame.minX + newWidth * 2, y: frame.minY, width: newWidth, height: newHeight)
            self.resizeWindow(newFrame: rect)
        break
        case self.keyCodeDict["RETURN"]:
            self.click(x: Int(frame.midX), y: Int(frame.midY))
        break
        default:
            let alert = NSAlert.init()
            alert.messageText = "Unsupported Keypress"
            alert.informativeText = "Please use the numpad numbers 1-9, or ENTER"
            alert.addButton(withTitle: "OK")
            alert.runModal()
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
            styleMask: [.titled],
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
    
    func resizeWindow(newFrame: NSRect) {
        self.window.setFrame(newFrame, display: true)
    }
    
    func click(x: Int, y: Int) {
        print("click at" + String(x) + " " + String(y))
    }
}
