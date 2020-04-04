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

    init(
        contentRect: NSRect,
        styleMask: StyleMask,
        backing: BackingStoreType,
        shouldDefer: Bool,
        keyDownHandler: @escaping (_ evt: NSEvent) -> Void
    ) {
        self.handleKeyDown = keyDownHandler

        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: shouldDefer)
        
    }
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        self.handleKeyDown(with)
    }
    
    // https://stackoverflow.com/a/8284133
    override var canBecomeKey: Bool { get { return true }}
    
}
