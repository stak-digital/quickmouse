import Foundation
import AppKit

class MenuBarManager {
    public static func makeMenuBar() -> NSStatusItem {
        // https://caseybrant.com/2019/02/20/macos-menu-bar-extras.html
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )

        statusBarItem.button?.image = NSImage(named: NSImage.columnViewTemplateName)

        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")

        statusBarItem.menu = statusBarMenu

        return statusBarItem
    }

    public static func addItem(_ menuBar: NSStatusItem, _ label: String, onChosen: Selector) -> Void {
        menuBar.menu?.addItem(withTitle: label, action: onChosen, keyEquivalent: "")
    }
}
