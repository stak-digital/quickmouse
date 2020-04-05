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
import Combine
import AppKit

class CellState: ObservableObject {
    @Published var activeCell: Int = 5
    @Published var downKeys: Array<Int> = []
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let cellState = CellState()
    
    var statusItem: NSStatusItem?
    
    var hotKeyMonitor: Any?
        
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
        "RETURN": 36,
        "ARROW_RIGHT": 124,
        "ARROW_LEFT": 123,
        "ARROW_UP": 126,
        "ARROW_DOWN": 125,
        "ESCAPE": 53,
        "INSERT": 114
    ]
    
    var window: NSWindow!
    var highlightedCell = 5
    
    func decrementColInRow(_ current: Int) -> Int {
        switch current {
        case 2:
            return 1
        case 3:
            return 2
        case 5:
            return 4
        case 6:
            return 5
        case 8:
            return 7
        case 9:
            return 8
        default:
            return current
        }
    }
    
    func incrementColInRow(_ current: Int) -> Int {
        switch current {
        case 1:
            return 2
        case 2:
            return 3
        case 4:
            return 5
        case 5:
            return 6
        case 7:
            return 8
        case 8:
            return 9
        default:
            return current
        }
    }
    
    func decrementRow(_ currentCol: Int) -> Int {
        switch currentCol {
        case 4...9:
            return currentCol - 3
        case 1...3:
            return currentCol
        default:
            return currentCol
        }
    }
    
    func incrementRow(_ currentCol: Int) -> Int {
        switch currentCol {
        case 7...9:
            return currentCol
        case 1...6:
            return currentCol + 3
        default:
            return currentCol
        }
    }
    
    var statusBarItem: NSStatusItem!
    
    func setupMenuBarIcon() {
// // https://caseybrant.com/2019/02/20/macos-menu-bar-extras.html
//        let statusBar = NSStatusBar.system
//        statusBarItem = statusBar.statusItem(
//            withLength: NSStatusItem.squareLength
//        )
//
//        statusBarItem.button?.title = "🌯"
//
//        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
//
//        statusBarItem.menu = statusBarMenu

        // https://medium.com/@hoishing/menu-bar-apps-f2d270150660
        
        statusItem = NSStatusBar.system.statusItem(withLength: -1)

        guard let button = statusItem?.button else {
            print("status bar item failed. Try removing some menu bar item.")
            NSApp.terminate(nil)
            return
        }

        button.image = NSImage(named: NSImage.flowViewTemplateName)
        button.target = self
        button.action = #selector(self.showWindow)
    }
    
    func resetCol() {
        self.cellState.activeCell = 5
    }
    
    func handleKeyUp(_ evt: NSEvent) {
        let keyCode = Int(evt.keyCode)
                
        let index = self.cellState.downKeys.firstIndex(of: keyCode)
        
        if (index != nil) {
            self.cellState.downKeys.remove(at: index!)
        }
        
        if (self.cellState.downKeys.count == 0) {
            if (keyCode != self.keyCodeDict["ESCAPE"]) {
                self.selectCol(self.cellState.activeCell)
            }
        }
    }
    
    func hideWindow() {
        self.window.orderBack(self)
        self.cellState.downKeys.removeAll(keepingCapacity: true)
    }
    
    @objc func showWindow() {
        self.cellState.downKeys.removeAll(keepingCapacity: true)
        self.resetWindowSize()
        NSApp!.activate(ignoringOtherApps: true)
        self.window.makeKeyAndOrderFront(self)
    }
    
    func selectCol(_ col: Int) {
        let currentSize = self.window.frame.size
        let frame = self.window.frame
        
        var rect: NSRect;
        
        let newWidth = currentSize.width / 3
        let newHeight = currentSize.height / 3
        
        switch col {
            case 7:
                rect = NSRect(x: frame.minX, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 8:
                rect = NSRect(x: frame.minX + newWidth, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 9:
                rect = NSRect(x: frame.minX + newWidth * 2, y: (((frame.maxY - frame.minY) / 3) * 2) + frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 4:
                rect = NSRect(x: frame.minX, y: frame.minY + newHeight, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 5:
                rect = NSRect(x: frame.minX + newWidth, y: frame.minY + newHeight, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 6:
                rect = NSRect(x: frame.minX + newWidth * 2, y: frame.minY + newHeight, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 1:
                rect = NSRect(x: frame.minX, y: frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 2:
                rect = NSRect(x: frame.minX + newWidth, y: frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            case 3:
                rect = NSRect(x: frame.minX + newWidth * 2, y: frame.minY, width: newWidth, height: newHeight)
                self.resizeWindow(newFrame: rect)
                break
            default:
                print("Unsupported cell")
                break
        }
    }
    
    func resetWindowSize() {
        let screenSize = CGDisplayBounds(CGMainDisplayID())
        let rect = NSRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.resizeWindow(newFrame: rect)
    }
    
    func myCallback(_ evt: NSEvent) {
        
        let keyCode = Int(evt.keyCode)
        let frame = self.window.frame
        
        if (self.cellState.downKeys.contains(keyCode) == false) {
            self.cellState.downKeys.append(keyCode)
        }
                        
        switch keyCode {
        case self.keyCodeDict["NUMPAD_7"]:
            self.selectCol(7)
            break
        case self.keyCodeDict["NUMPAD_8"]:
            self.selectCol(8)
            break
        case self.keyCodeDict["NUMPAD_9"]:
            self.selectCol(9)
            break
        case self.keyCodeDict["NUMPAD_4"]:
            self.selectCol(4)
            break
        case self.keyCodeDict["NUMPAD_5"]:
            self.selectCol(5)
            break
        case self.keyCodeDict["NUMPAD_6"]:
            self.selectCol(6)
            break
        case self.keyCodeDict["NUMPAD_1"]:
            self.selectCol(1)
            break
        case self.keyCodeDict["NUMPAD_2"]:
            self.selectCol(2)
            break
        case self.keyCodeDict["NUMPAD_3"]:
            self.selectCol(3)
            break
        case self.keyCodeDict["ARROW_LEFT"]:
            self.cellState.activeCell = decrementColInRow(self.cellState.activeCell)
            break
        case self.keyCodeDict["ARROW_RIGHT"]:
            self.cellState.activeCell = incrementColInRow(self.cellState.activeCell)
            break
        case self.keyCodeDict["ARROW_UP"]:
            self.cellState.activeCell = incrementRow(self.cellState.activeCell)
            break
        case self.keyCodeDict["ARROW_DOWN"]:
            self.cellState.activeCell = decrementRow(self.cellState.activeCell)
            break
        case self.keyCodeDict["ESCAPE"]:
            self.resetWindowSize()
            break
        case self.keyCodeDict["RETURN"]:
            self.hideWindow() // this is slow to close, so we need to add a delay before we trigger click
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
                
            }
            break
        default:
            print(keyCode)
            let alert = NSAlert.init()
            alert.messageText = "Unsupported Keypress"
            alert.informativeText = "Please use the numpad numbers 1-9, or Arrow Keys, or ESCAPE or ENTER"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    func handleGlobalKeyPressed(_ event: NSEvent) {
        let keyCode = Int(event.keyCode)
        
        if (keyCode == self.keyCodeDict["INSERT"]) {
            if (event.modifierFlags.contains(.command)) {
                self.showWindow()
            }
        }
    }
    
    func listenForGlobalHotKey() {
        self.hotKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.handleGlobalKeyPressed)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(self.cellState).background(Color.clear)
        //        let menubarHeight: Float = 20
        let screenSize = CGDisplayBounds(CGMainDisplayID())
        
        let fullScreenWindowRect = NSRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 20) // replace 20 with `menubarHeight`
        
        // The application does not appear in the Dock and does not have a menu
        // bar, but it may be activated programmatically or by clicking on one
        // of its windows.
        NSApp!.setActivationPolicy(.accessory)
        
        self.setupMenuBarIcon()
        
        // Create the window and set the content view.
        window = MyWindow(
            contentRect: fullScreenWindowRect,
            styleMask: [],
            backing: .buffered,
            shouldDefer: false,
            keyDownHandler: myCallback,
            keyUpHandler: handleKeyUp
        )
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        self.showWindow()
        window.isOpaque = false
        window.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0)
        window.setFrame(fullScreenWindowRect, display: true)
        
        
        self.listenForGlobalHotKey()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func resizeWindow(newFrame: NSRect) {
        self.resetCol()
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
