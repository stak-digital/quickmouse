import Foundation

private class CellState: ObservableObject {
    @Published var activeCell: Int = 5
    @Published var downKeys: Array<Int> = []
}

class GridManager: ObservableObject {
    // the list of selections that the user has made. eg:
    // [1, 5, 9] means the user selected top-left on the first zoom level, then the middle cell on the second zoom level, then the
    // bottom-right cell ont he third zoom level (assuming a 1-indexed 3x3 grid)
    var selectedCells: Array<Int> = []
    @Published var highlightedCell = 5
    private let cellState = CellState()

    func hasAnyZoom() -> Bool {
     return selectedCells.count != 0
    }

    func centerHighlight() {
        highlightedCell = 5
    }

    func moveHighlightTo(_ cellNumber: Int) -> Void {
        highlightedCell = cellNumber
    }

    func zoomInOnCell(_ cellNumber: Int) -> Void {
        selectedCells.append(cellNumber)
    }

    func zoomInOnHighlightedCell() -> Void {
        zoomInOnCell(highlightedCell)
    }

    func zoomOut() -> Void {
        selectedCells.removeLast()
    }

    func resetZoom() -> Void {
        selectedCells.removeAll()
    }

    func moveHighlightUp() -> Void {
        highlightedCell = CellManager.incrementRow(highlightedCell)
    }

    func moveHighlightDown() -> Void {
        highlightedCell = CellManager.decrementRow(highlightedCell)
    }

    func moveHighlightLeft() -> Void {
        highlightedCell = CellManager.decrementCol(highlightedCell)
    }

    func moveHighlightRight() -> Void {
        highlightedCell = CellManager.incrementCol(highlightedCell)
    }
}
