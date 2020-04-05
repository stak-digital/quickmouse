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
    
    var window: NSWindow!
    var highlightedCell = 5
    
    
    
    var statusBarItem: NSStatusItem!
    
    func setupMenuBarIcon() {
// // https://caseybrant.com/2019/02/20/macos-menu-bar-extras.html
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )

        statusBarItem.button?.image = NSImage(named: NSImage.columnViewTemplateName)

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")

        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "Show Quickmouse",
            action: #selector(self.showWindow),
            keyEquivalent: ""
        )
        
        statusBarMenu.addItem(
            withTitle: "Quit Quickmouse",
            action: #selector(self.quit),
            keyEquivalent: ""
        )

//        // https://medium.com/@hoishing/menu-bar-apps-f2d270150660
//
//        statusItem = NSStatusBar.system.statusItem(withLength: -1)
//
//        guard let button = statusItem?.button else {
//            print("status bar item failed. Try removing some menu bar item.")
//            NSApp.terminate(nil)
//            return
//        }
//
//        button.image = NSImage(named: NSImage.columnViewTemplateName)
//        button.target = self
//        button.action = #selector(self.showWindow)
    }
    
    @objc func quit() {
        exit(0)
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
            if (keyCode != KeyboardManager.keyCodes["ESCAPE"]) {
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
        let maxCellNumber = (CellManager.cols * CellManager.rows)

        switch col {
            case 1...maxCellNumber:
                let virtualFrame = WindowManager.convertToVirtualFrame(self.window.frame)
                let nextFrame: NSRect = WindowManager.getRectForCell(currentRect: virtualFrame, whichCell: col)
                self.resizeWindow(newFrame: nextFrame)
            break
            default:
                print("Unsupported cell")
            break
        }
    }
    
    func resetWindowSize() {
        self.resizeWindow(newFrame: WindowManager.getScreenSize())
    }
    
    func handleKeyDown(_ evt: NSEvent) {
        
        let keyCode = Int(evt.keyCode)
        
        if (self.cellState.downKeys.contains(keyCode) == false) {
            self.cellState.downKeys.append(keyCode)
        }
                        
        switch keyCode {
        case KeyboardManager.keyCodes["NUMPAD_7"]:
            self.selectCol(7)
            break
        case KeyboardManager.keyCodes["NUMPAD_8"]:
            self.selectCol(8)
            break
        case KeyboardManager.keyCodes["NUMPAD_9"]:
            self.selectCol(9)
            break
        case KeyboardManager.keyCodes["NUMPAD_4"]:
            self.selectCol(4)
            break
        case KeyboardManager.keyCodes["NUMPAD_5"]:
            self.selectCol(5)
            break
        case KeyboardManager.keyCodes["NUMPAD_6"]:
            self.selectCol(6)
            break
        case KeyboardManager.keyCodes["NUMPAD_1"]:
            self.selectCol(1)
            break
        case KeyboardManager.keyCodes["NUMPAD_2"]:
            self.selectCol(2)
            break
        case KeyboardManager.keyCodes["NUMPAD_3"]:
            self.selectCol(3)
            break
        case KeyboardManager.keyCodes["ARROW_LEFT"]:
            self.cellState.activeCell = CellManager.decrementCol(self.cellState.activeCell)
            break
        case KeyboardManager.keyCodes["ARROW_RIGHT"]:
            self.cellState.activeCell = CellManager.incrementCol(self.cellState.activeCell)
            break
        case KeyboardManager.keyCodes["ARROW_UP"]:
            self.cellState.activeCell = CellManager.incrementRow(self.cellState.activeCell)
            break
        case KeyboardManager.keyCodes["ARROW_DOWN"]:
            self.cellState.activeCell = CellManager.decrementRow(self.cellState.activeCell)
            break
        case KeyboardManager.keyCodes["ESCAPE"]:
            self.cellState.downKeys.removeAll()
            self.resetWindowSize()
            break
        case KeyboardManager.keyCodes["RETURN"]:
            self.submit()
            break
        case KeyboardManager.keyCodes["INSERT"]:
            print("hotkey called while app had focus anyway")
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
    
    func submit() {
        let screenSize = WindowManager.getScreenSize()
        let frame = self.window.frame
        
        self.hideWindow() // this is slow to close, so we need to add a delay before we trigger click
        // or else it'll just click our own app window
        
        let clickPos: NSPoint = NSPoint(
            x: frame.midX,
            y: screenSize.height - frame.midY
        ) // click at the middle of the middle cell
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // once to change the window focus to the target app
            MouseManager.click(clickPos)
            
            // once to actually click
            MouseManager.click(clickPos)
        }
    }
    
    func handleGlobalKeyPressed(_ event: NSEvent) {
        let keyCode = Int(event.keyCode)
        
        if (keyCode == KeyboardManager.keyCodes["INSERT"]) {
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
        
        // The application does not appear in the Dock and does not have a menu
        // bar, but it may be activated programmatically or by clicking on one
        // of its windows.
        NSApp!.setActivationPolicy(.accessory)
        
        self.setupMenuBarIcon()
        
        // Create the window and set the content view.
        window = MyWindow(
            contentRect: WindowManager.getScreenSize(),
            styleMask: [],
            backing: .buffered,
            shouldDefer: false,
            keyDownHandler: handleKeyDown,
            keyUpHandler: handleKeyUp
        )
        
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.isOpaque = false
        window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.showWindow()
        self.listenForGlobalHotKey()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func resizeWindow(newFrame: NSRect) {
        self.resetCol()
        self.window.setFrame(
            WindowManager.convertToBufferFrame(newFrame),
            display: true
        )
    }
    
    func postMouseEvent(button: CGMouseButton, type: CGEventType, point: CGPoint) {
        if let theEvent: CGEvent = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: button) {
            theEvent.type = type;
            theEvent.post(tap: .cghidEventTap);
        } else {
            print("I dunno")
        }
    }
}
