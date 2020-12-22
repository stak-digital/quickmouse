import Foundation
import Cocoa

class MyWindow: NSWindow {
    
    var handleKeyDown: (_ evt: NSEvent) -> ();
    var handleKeyUp: (_ evt: NSEvent) -> ();
    var handleFlagsChange: (_ evt: NSEvent) -> ();

    init(
        contentRect: NSRect,
        styleMask: StyleMask,
        backing: BackingStoreType,
        shouldDefer: Bool,
        keyDownHandler: @escaping (_ evt: NSEvent) -> Void,
        keyUpHandler: @escaping (_ evt: NSEvent) -> Void,
        flagsChangeHandler: @escaping (_ evt: NSEvent) -> Void
    ) {
        handleKeyDown = keyDownHandler
        handleKeyUp = keyUpHandler
        handleFlagsChange = flagsChangeHandler

        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: shouldDefer)
    }
    
    override func keyDown(with: NSEvent) {
        handleKeyDown(with)
    }
    
    override func keyUp(with event: NSEvent) {
        handleKeyUp(event)
    }
    
    override func flagsChanged(with event: NSEvent) {
        handleFlagsChange(event)
    }
    
    // https://stackoverflow.com/a/8284133
    override var canBecomeKey: Bool { get { true }}
    
    override var isReleasedWhenClosed: Bool { get { false } set {  } }
    
}
