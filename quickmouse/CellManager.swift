//
//  CellManager.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 5/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

import Foundation

class CellManager {
    static let rows = 3
    static let cols = 3
    
    static func decrementCol(_ current: Int, cols: Int) -> Int {
        if (current % cols == 1) {
            return current
        }

        return current - 1
    }
    
    static func incrementCol(_ current: Int, cols: Int) -> Int {
        if (current % cols == 0) {
            return current
        }

        return current + 1
    }
    
    static func decrementRow(_ currentCol: Int, cols: Int, rows: Int) -> Int {
        let newCol = currentCol - cols
        let minCol = 0

        if (newCol < minCol) {
            return currentCol
        } else {
            return newCol
        }
    }
    
    static func incrementRow(_ currentCol: Int, cols: Int, rows: Int) -> Int {
        let newCol = currentCol + cols
        let maxCol = cols * rows

        if (newCol > maxCol) {
            return currentCol
        } else {
            return newCol
        }
    }
}
