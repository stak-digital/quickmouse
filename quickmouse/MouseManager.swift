//
//  MouseManager.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 5/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

import Foundation

class MouseManager {
    public static func click(_ atPoint: NSPoint) {
        let x = atPoint.x
        let y = atPoint.y
        
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
        
        usleep(250_000)

        if let eUp = eventUp {
            eUp.post(tap: .cghidEventTap)
        } else {
            print("Click didn't happen")
        }
    }
}
