import Foundation

class GridManager: ObservableObject {
    public let rows: Int
    public let cols: Int
    // the list of selections that the user has made. eg:
    // [1, 5, 9] means the user selected top-left on the first zoom level, then the middle cell on the second zoom level, then the
    // bottom-right cell ont he third zoom level (assuming a 1-indexed 3x3 grid)
    var selectedCells: Array<Int> = []
    @Published var highlightedCell = 5

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
    }

    func hasAnyZoom() -> Bool {
     selectedCells.count != 0
    }

    func centerHighlight() {
        let cells = Float(rows) * Float(cols)
        let middle = cells / 2
        highlightedCell = Int(ceil(Double(middle)))
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
        highlightedCell = CellManager.incrementRow(highlightedCell, cols: cols, rows: rows)
    }

    func moveHighlightDown() -> Void {
        highlightedCell = CellManager.decrementRow(highlightedCell, cols: cols, rows: rows)
    }

    func moveHighlightLeft() -> Void {
        highlightedCell = CellManager.decrementCol(highlightedCell, cols: cols)
    }

    func moveHighlightRight() -> Void {
        highlightedCell = CellManager.incrementCol(highlightedCell, cols: cols)
    }
}
