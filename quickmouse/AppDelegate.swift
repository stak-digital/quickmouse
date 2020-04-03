//
//  AppDelegate.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 3/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

import Cocoa
import SwiftUI
import ApplicationServices

//import "ClickAction.h"

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
    var highlightedCell = 5
    
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
            self.window.close() // this is slow to close, so we need to add a delay before we trigger click
            // or else it'll just click our own app window
            
            let screenSize = CGDisplayBounds(CGMainDisplayID())
            
            let clickPos: NSPoint = NSPoint(
                x: frame.midX,
                y: screenSize.height - frame.midY
            ) // click at the middle of the middle cell
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                self.click(
                    x: Int(clickPos.x),
                    y: Int(clickPos.y)
                ) // click at the middle of the middle cell
                
                self.click(
                    x: Int(clickPos.x),
                    y: Int(clickPos.y)
                ) // click at the middle of the middle cell
                
                exit(0)
            }
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
    
    func postMouseEvent(button: CGMouseButton, type: CGEventType, point: CGPoint) {
        if let theEvent: CGEvent = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: button) {
            theEvent.type = type;
            theEvent.post(tap: .cghidEventTap);
        } else {
            print("I dunno")
        }
        
    }
    
    
    func click(x: Int, y: Int) {
        print("click at " + String(x) + "x" + String(y))
        
        let position = CGPoint(x: x, y: y)
        
        let source = CGEventSource.init(stateID: .hidSystemState)
        let eventDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: position , mouseButton: .left)
        let eventUp = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: position , mouseButton: .left)
        
        if let eDown = eventDown {
            /*
              These events will never actually be received by the system if there has been a code change
              since the last build and you haven't toggled the Mac OS System Preferences -> Security & Privacy -> Accessibility
              checkbox for this app. It will fail silently unless you uncheck it and re-check it again once per code change.
             
              Also these events require the App Sandbox to be disabled.
             */
            eDown.post(tap: .cghidEventTap)
        } else {
            print("Click didn't happen")
        }
        
        usleep(500_000)
        
        
        if let eUp = eventUp {
            eUp.post(tap: .cghidEventTap)
        } else {
            print("Click didn't happen")
        }
    }
}
