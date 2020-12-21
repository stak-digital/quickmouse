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
    
    // the list of selections that the user has made. eg:
    // [1, 5, 9] means the user selected top-left on the first zoom level, then the middle cell on the second zoom level, then the
    // bottom-right cell ont he third zoom level (assuming a 1-indexed 3x3 grid)
    var selectedCells: Array<Int> = []
    
    func setupMenuBarIcon() {
        // https://caseybrant.com/2019/02/20/macos-menu-bar-extras.html
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
    }
    
    @objc func quit() {
        exit(0)
    }
    
    func resetCol() {
        self.cellState.activeCell = 5
    }
    
    func handleKeyUp(_ evt: NSEvent) {
//        let keyCode = Int(evt.keyCode)
//
//        let index = self.cellState.downKeys.firstIndex(of: keyCode)
//
//        if (index != nil) {
//            self.cellState.downKeys.remove(at: index!)
//        }
//
//        if (self.cellState.downKeys.count == 0) {
//            switch keyCode {
//                case KeyboardManager.keyCodes["ARROW_UP"],
//                     KeyboardManager.keyCodes["ARROW_RIGHT"],
//                     KeyboardManager.keyCodes["ARROW_DOWN"],
//                     KeyboardManager.keyCodes["ARROW_LEFT"]:
////                case KeyboardManager.keyCodes["ESCAPE"], KeyboardManager.keyCodes["INSERT"],
////                     KeyboardManager.keyCodes["SPACE"]:
//                self.selectCol(self.cellState.activeCell)
//                    break
//            default:
////                self.selectCol(self.cellState.activeCell)
//                break
//            }
//        }
    }
    
    func hideWindow() {
        // https://stackoverflow.com/a/48353056/1063035
        // hides the window. This is necessary because `window.orderOut` doesn't give focus to the next-underneath window.
        NSApp.hide(self)
        self.cellState.downKeys.removeAll(keepingCapacity: true)
    }
    
    @objc func showWindow() {
        self.cellState.downKeys.removeAll(keepingCapacity: true)
        self.resetWindowSize()
        NSApp.unhide(self)
        NSApp!.activate(ignoringOtherApps: true)
        self.window.makeKeyAndOrderFront(self)
    }
    
    func selectCol(_ col: Int) {
        self.selectedCells.append(col)
        self.renderWindow()
        
//        let maxCellNumber = (CellManager.cols * CellManager.rows)
//
//        switch col {
//            case 1...maxCellNumber:
//                let virtualFrame = WindowManager.convertToVirtualFrame(self.window.frame)
//                let nextFrame: NSRect = WindowManager.getRectForCell(currentRect: virtualFrame, whichCell: col)
//                self.resizeWindow(newFrame: nextFrame)
//            break
//            default:
//                print("Unsupported cell")
//            break
//        }
    }
    
    func undoColSelection() {
        
        // if full-size already, we can't go any further, so just close the window.
        // todo: maybe this should quit the app?
        if (self.selectedCells.count == 0) {
            self.hideWindow()
            return
        }
        
        self.selectedCells.removeLast()
        self.renderWindow()
    }
    
    // given a list of sleected cells, work
    func calculateWindowSize( selectedCells: Array<Int>) -> NSRect {
        var rect: NSRect = WindowManager.getScreenSize()
        
        // TODO: just use a reduce() here
        selectedCells.forEach({ cell in
            rect = WindowManager.getRectForCell(currentRect: rect, whichCell: cell)
        })
        
        return rect
    }
    
    func resetWindowSize() {
        self.resizeWindow(newFrame: WindowManager.getScreenSize())
    }
    
    func renderWindow() {
        print(self.selectedCells)

        self.resizeWindow(
            newFrame: self.calculateWindowSize(
                selectedCells: self.selectedCells
            )
        )
    }
    
    func handleKeyDown(_ evt: NSEvent) {
        
        let keyCode = Int(evt.keyCode)
        
        if (self.cellState.downKeys.contains(keyCode) == false) {
            self.cellState.downKeys.append(keyCode)
        }
                        
        switch keyCode {
        case KeyboardManager.keyCodes["NUMPAD_7"], KeyboardManager.keyCodes["DIGIT_7"]:
            self.selectCol(7)
            break
        case KeyboardManager.keyCodes["NUMPAD_8"], KeyboardManager.keyCodes["DIGIT_8"]:
            self.selectCol(8)
            break
        case KeyboardManager.keyCodes["NUMPAD_9"], KeyboardManager.keyCodes["DIGIT_9"]:
            self.selectCol(9)
            break
        case KeyboardManager.keyCodes["NUMPAD_4"], KeyboardManager.keyCodes["DIGIT_4"]:
            self.selectCol(4)
            break
        case KeyboardManager.keyCodes["NUMPAD_5"], KeyboardManager.keyCodes["DIGIT_5"]:
            self.selectCol(5)
            break
        case KeyboardManager.keyCodes["NUMPAD_6"], KeyboardManager.keyCodes["DIGIT_6"]:
            self.selectCol(6)
            break
        case KeyboardManager.keyCodes["NUMPAD_1"], KeyboardManager.keyCodes["DIGIT_1"]:
            self.selectCol(1)
            break
        case KeyboardManager.keyCodes["NUMPAD_2"], KeyboardManager.keyCodes["DIGIT_2"]:
            self.selectCol(2)
            break
        case KeyboardManager.keyCodes["NUMPAD_3"], KeyboardManager.keyCodes["DIGIT_3"]:
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
            self.undoColSelection()
            break
        case KeyboardManager.keyCodes["SPACE"]:
            self.selectCol(self.cellState.activeCell)
        break
        case KeyboardManager.keyCodes["RETURN"]:
            self.submit()
            break
        case KeyboardManager.keyCodes["INSERT"]:
//            self.showWindow()
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
        
        print(keyCode)
                
//        if (keyCode == KeyboardManager.keyCodes["GRAVE_ACCENT"]) {
//            if (event.modifierFlags.contains(.control)) {
//                self.showWindow()
//            }
//        }
    }
    
    // TODO: only do it on a double-tap of Caps Lock (or maybe trigger it on CTRL+CAPS?)
    func handleFlagsChanged(_ event: NSEvent) {
        print(event)
        
        let isCapsLockOn = event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
        let isControlKeyDown = event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.control)

        if (isCapsLockOn && isControlKeyDown) {
            self.showWindow()
        }
    }
    
    func listenForGlobalHotKey() {
        self.hotKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.handleGlobalKeyPressed)
        self.hotKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged], handler: self.handleFlagsChanged)
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
            keyUpHandler: handleKeyUp,
            flagsChangeHandler: handleFlagsChanged
        )
        
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.isOpaque = false
        window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        
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
    
    // WARNING: this won't work unless the App has been given the correct access to the Accessibility API:
    // https://stackoverflow.com/a/56928709
    // In development, it will require that you toggle the checkbox off and EVERY TIME YOU CHANGE THE CODE AND REBUILD
    func postMouseEvent(button: CGMouseButton, type: CGEventType, point: CGPoint) {
        if let theEvent: CGEvent = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: button) {
            theEvent.type = type;
            theEvent.post(tap: .cghidEventTap);
        } else {
            print("I dunno")
        }
    }
}
