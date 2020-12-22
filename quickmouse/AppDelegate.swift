import Cocoa
import SwiftUI
import ApplicationServices
import Combine
import AppKit

// note: LSUIElement (Application is agent) has been set to true in the Info.plist file
// see https://apple.stackexchange.com/a/92017

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var hotKeyMonitor: Any?
    var window: NSWindow!
    var statusBarItem: NSStatusItem = MenuBarManager.makeMenuBar()
    var flagChangePool: Array<NSEvent> = []
    let grid = GridManager()

    func quit() {
        exit(0)
    }

    func handleKeyUp(_ evt: NSEvent) {

    }

    @objc func handleQuitFromMenuRequested() {
        quit()
    }

    @objc func handleShowFromMenuRequested() {
        resetEverything()
        showWindow()
    }

    func resetEverything() {
        grid.resetZoom()
        grid.centerHighlight()
        renderWindow()
    }

    func removeOldestEventFromFlagChangePool() -> Void {
        /*
         * need this check because if the async queuing of this fn ends up calling when
         * the array is already empty, it crashes.
         */
        if (flagChangePool.count > 0) {
            flagChangePool.remove(at: 0)
        }
    }

    func hideWindow() {
        // https://stackoverflow.com/a/48353056/1063035
        // hides the window. This is necessary because `window.orderOut` doesn't give focus to the next-underneath window.
        NSApp.hide(self)
    }

    @objc func showWindow() {
        NSApp.unhide(self)
        NSApp!.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }

    func isWindowShowing() -> Bool {
        NSApp.isHidden
    }

    func selectHighlightedCell() {
        grid.zoomInOnHighlightedCell()
        grid.centerHighlight()
        renderWindow()
    }

    func undoColSelection() {
        /*
         * If full-size already, we can't go any further, so just close the window.
         */
        if (grid.hasAnyZoom()) {
            grid.zoomOut()
            renderWindow()
        } else {
            hideWindow()
        }
    }

    // given a list of selected cells, split the screen successively to zoom in each step
    func calculateGridSize() -> NSRect {
        var rect: NSRect = WindowManager.getScreenSize()

        // TODO: just use a reduce() here
        grid.selectedCells.forEach({ cell in
            rect = WindowManager.getRectForCell(currentRect: rect, whichCell: cell)
        })

        return rect
    }

    func renderWindow() {
        window.setFrame(
            WindowManager.convertToBufferFrame(calculateGridSize()),
            display: true
        )
    }

    func handleKeyDown(_ evt: NSEvent) {
        let keyCode = Int(evt.keyCode)

        switch keyCode {
        case KeyboardManager.keyCodes["NUMPAD_7"], KeyboardManager.keyCodes["DIGIT_7"]:
            grid.moveHighlightTo(7)
            break
        case KeyboardManager.keyCodes["NUMPAD_8"], KeyboardManager.keyCodes["DIGIT_8"]:
            grid.moveHighlightTo(8)
            break
        case KeyboardManager.keyCodes["NUMPAD_9"], KeyboardManager.keyCodes["DIGIT_9"]:
            grid.moveHighlightTo(9)
            break
        case KeyboardManager.keyCodes["NUMPAD_4"], KeyboardManager.keyCodes["DIGIT_4"]:
            grid.moveHighlightTo(4)
            break
        case KeyboardManager.keyCodes["NUMPAD_5"], KeyboardManager.keyCodes["DIGIT_5"]:
            grid.moveHighlightTo(5)
            break
        case KeyboardManager.keyCodes["NUMPAD_6"], KeyboardManager.keyCodes["DIGIT_6"]:
            grid.moveHighlightTo(6)
            break
        case KeyboardManager.keyCodes["NUMPAD_1"], KeyboardManager.keyCodes["DIGIT_1"]:
            grid.moveHighlightTo(1)
            break
        case KeyboardManager.keyCodes["NUMPAD_2"], KeyboardManager.keyCodes["DIGIT_2"]:
            grid.moveHighlightTo(2)
            break
        case KeyboardManager.keyCodes["NUMPAD_3"], KeyboardManager.keyCodes["DIGIT_3"]:
            grid.moveHighlightTo(3)
            break
        case KeyboardManager.keyCodes["ARROW_LEFT"]:
            grid.moveHighlightLeft()
            break
        case KeyboardManager.keyCodes["ARROW_RIGHT"]:
            grid.moveHighlightRight()
            break
        case KeyboardManager.keyCodes["ARROW_UP"]:
            grid.moveHighlightUp()
            break
        case KeyboardManager.keyCodes["ARROW_DOWN"]:
            grid.moveHighlightDown()
            break
        case KeyboardManager.keyCodes["ESCAPE"]:
            undoColSelection()
            break
        case KeyboardManager.keyCodes["SPACE"]:
            selectHighlightedCell()
            break
        case KeyboardManager.keyCodes["RETURN"]:
            submit()
            break
        default:
            showModal(
                title: "Unsupported Keypress",
                body: "Please use the numpad numbers 1-9, or Arrow Keys, or ESCAPE or ENTER",
                buttonText: "OK"
            )
        }

        moveMouseToHighlightedCell()
    }

    func showModal(title: String, body: String, buttonText: String) -> Void {
        let alert = NSAlert.init()
        alert.messageText = title
        alert.informativeText = body
        alert.addButton(withTitle: buttonText)
        alert.runModal()
    }

    func submit() {
        hideWindow()
        MouseManager.click(getCenterPositionOfHighlightedCell())
    }

    func handleFlagsChanged(_ event: NSEvent) {
        let isControlKeyDownRightNow = event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.control)

        if (!isControlKeyDownRightNow) {
            return
        }

        // add this event to a list of recent flag change events
        flagChangePool.append(event)

        var eventsWithControlKeyDown: Array<NSEvent> = []

        flagChangePool.forEach({ evt in
            let isControlKeyDown = evt.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.control)

            if (isControlKeyDown) {
                eventsWithControlKeyDown.append(evt)
            }
        })


        if (eventsWithControlKeyDown.count >= 2) {
            /*
             * Unhide
             */
            if (isWindowShowing()) {
                resetEverything()
                showWindow()
                moveMouseToHighlightedCell()
            } else {
                hideWindow()
            }

            // flush them all so that if the user presses it one more time, there won't be maybe 3 valid events in the time window
            // causing only one more press to toggle again
            // TODO: cancel all queued deletion calls from below!
            flagChangePool.removeAll()
        } else {
            // schedule the removal of this event from the list of flag change events
            // todo: it doesn't really remove THIS event.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33333 /* seconds */) {
                self.removeOldestEventFromFlagChangePool()
            }
        }
    }

    func listenForGlobalHotKey() {
        hotKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged], handler: handleFlagsChanged)
    }

    func applicationWillTerminate(_ notification: Notification) {
        if (hotKeyMonitor != nil) {
            NSEvent.removeMonitor(hotKeyMonitor!)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(grid).background(Color.clear)

        // The application does not appear in the Dock and does not have a menu
        // bar, but it may be activated programmatically or by clicking on one
        // of its windows.
        NSApp!.setActivationPolicy(.accessory)

        MenuBarManager.addItem(statusBarItem, "Show QuickMouse", onChosen: #selector(handleShowFromMenuRequested))
        MenuBarManager.addItem(statusBarItem, "Quit QuickMouse", onChosen: #selector(handleQuitFromMenuRequested))

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

        /*
         * Add the SwiftUI view as the renderable part of the window
         */
        window.contentView = NSHostingView(rootView: contentView)
        window.isOpaque = false
        window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)

        /*
         * Ensure our application is drawn with a high-enough z-index to cover not just the applications,
         * but also the menubar.

         * see: https://stackoverflow.com/a/18509390/1063035
         */
        window.level = NSWindow.Level.popUpMenu

        /*
         * Ensure we don't have to set the focus to the underlying window before we trigger a click

         * see: https://stackoverflow.com/a/18023371/1063035
         */
        window.ignoresMouseEvents = true

        resetEverything()
        hideWindow()
        listenForGlobalHotKey()
    }

    func getCenterPositionOfHighlightedCell() -> NSPoint {
        let gridContainer: NSRect = WindowManager.getRectForCell(
            currentRect: calculateGridSize(),
            whichCell: grid.highlightedCell
        )
        return NSPoint(x: gridContainer.midX, y: gridContainer.midY)
    }

    func moveMouseToHighlightedCell() {
        MouseManager.moveTo(getCenterPositionOfHighlightedCell())
    }
}
