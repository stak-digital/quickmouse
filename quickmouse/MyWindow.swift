//
//  MyWindow.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 3/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

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
        self.handleKeyDown = keyDownHandler
        self.handleKeyUp = keyUpHandler
        self.handleFlagsChange = flagsChangeHandler

        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: shouldDefer)
        
    }
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        self.handleKeyDown(with)
    }
    
    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        self.handleKeyUp(event)
    }
    
    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
        self.handleFlagsChange(event)
    }
    
    // https://stackoverflow.com/a/8284133
    override var canBecomeKey: Bool { get { return true }}
    
    override var isReleasedWhenClosed: Bool { get { return false } set {  } }
    
}
