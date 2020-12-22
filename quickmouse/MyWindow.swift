import Foundation
import Cocoa

class MyWindow: NSWindow {
    
    var handleKeyUp: (_ evt: NSEvent) -> ();
    var handleFlagsChange: (_ evt: NSEvent) -> ();

    init(
        contentRect: NSRect,
        styleMask: StyleMask,
        backing: BackingStoreType,
        shouldDefer: Bool,
        keyUpHandler: @escaping (_ evt: NSEvent) -> Void,
        flagsChangeHandler: @escaping (_ evt: NSEvent) -> Void
    ) {
        handleKeyUp = keyUpHandler
        handleFlagsChange = flagsChangeHandler

        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: shouldDefer)
    }
    
    override func keyUp(with: NSEvent) {
        handleKeyUp(with)
    }

    override func keyDown(with: NSEvent) {
        // do nothing, and interrupt the super class from receiving the event.
        // this will stop the event propagation up to the system level which will cause
        // a bell/"doonk" sound.
        // see: https://developer.apple.com/forums/thread/63278#180090022
    }

    override func flagsChanged(with event: NSEvent) {
        handleFlagsChange(event)
    }
    
    // https://stackoverflow.com/a/8284133
    override var canBecomeKey: Bool { get { true }}
    
    override var isReleasedWhenClosed: Bool { get { false } set {  } }
    
}
