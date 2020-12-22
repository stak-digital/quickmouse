//
//  WindowManager.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 5/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

import Foundation

class WindowManager {
    
    // todo: memoize this and invalidate on screen resize
    public static func getScreenSize() -> CGRect {
        return CGDisplayBounds(CGMainDisplayID())
    }
    
    public static func getRectForCell(currentRect: NSRect, whichCell: Int) -> NSRect {
        let smallerWidth = CGFloat(Int(currentRect.width) / CellManager.cols)
        let smallerHeight = CGFloat(Int(currentRect.height) / CellManager.rows)
        
        var newX: CGFloat = currentRect.minX
        var newY: CGFloat = currentRect.minY
        let newWidth: CGFloat = smallerWidth
        let newHeight: CGFloat = smallerHeight
                
        // set new X position
        switch whichCell {
            case 2, 5, 8:
                newX = newX + smallerWidth
            break
            case 3, 6, 9:
                newX = newX + (smallerWidth * 2)
            break
            default:
            break
        }
        
        // set new Y position
        switch whichCell {
            case 4, 5, 6:
                newY = newY + (smallerHeight * 1)
            break
            case 1, 2, 3:
                newY = newY + (smallerHeight * 2)
            break
            default:
            break
        }
        
        let result = NSRect(
            x: newX,
            y: newY,
            width: newWidth,
            height: newHeight
        )
        
        return result
    }
    
    public static func invertYAxisValue(_ yVal: CGFloat, _ height: CGFloat) -> CGFloat {
        let screenSize = WindowManager.getScreenSize()
        
        return screenSize.height - (height + yVal)
    }
    
    public static func deInvert(_ yVal: CGFloat) -> CGFloat {
        let screenSize = WindowManager.getScreenSize()

        return screenSize.height - yVal
    }
    
    // a virtual frame is one where y0 is at the top of the screen, unlike the NSWindow origin (y0 is at the bottom for that)
    public static func convertToVirtualFrame(_ bufferFrame: NSRect) -> NSRect {
        return NSRect(
           x: bufferFrame.minX,
           y: WindowManager.deInvert(bufferFrame.maxY),
           width: bufferFrame.width,
           height: bufferFrame.height
        )
    }

    public static func convertToBufferPoint(_ virtualPoint: NSPoint, _ screenHeight: Float) -> NSPoint {
        NSPoint(
           x: virtualPoint.x,
            y: WindowManager.invertYAxisValue(virtualPoint.y, CGFloat(screenHeight))
        )
    }
    
    public static func convertToBufferFrame(_ virtualFrame: NSRect) -> NSRect {
        return NSRect(
           x: virtualFrame.minX,
           y: WindowManager.invertYAxisValue(virtualFrame.minY, virtualFrame.height),
           width: virtualFrame.width,
           height: virtualFrame.height
        )
    }
}
