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
    
    static func decrementCol(_ current: Int) -> Int {
        switch current {
        case 2:
            return 1
        case 3:
            return 2
        case 5:
            return 4
        case 6:
            return 5
        case 8:
            return 7
        case 9:
            return 8
        default:
            return current
        }
    }
    
    static func incrementCol(_ current: Int) -> Int {
        switch current {
        case 1:
            return 2
        case 2:
            return 3
        case 4:
            return 5
        case 5:
            return 6
        case 7:
            return 8
        case 8:
            return 9
        default:
            return current
        }
    }
    
    static func decrementRow(_ currentCol: Int) -> Int {
        switch currentCol {
        case 4...9:
            return currentCol - CellManager.cols
        case 1...3:
            return currentCol
        default:
            return currentCol
        }
    }
    
    static func incrementRow(_ currentCol: Int) -> Int {
        switch currentCol {
        case 7...9:
            return currentCol
        case 1...6:
            return currentCol + CellManager.cols
        default:
            return currentCol
        }
    }
}
