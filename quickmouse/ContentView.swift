import SwiftUI

struct Col: View {
    var number: Int;
    var isHighlighted: Bool
    
    static func getTextSize(_ frameSize: GeometryProxy) -> CGFloat {
        CGFloat(frameSize.size.width > 100 ? 30 : 15)
    }

    static func getPaddingSize(_ frameSize: GeometryProxy) -> CGFloat {
        CGFloat(frameSize.size.width > 100 ? 20 : 7)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: Col.getPaddingSize(geometry))
                    Text(String(number))
                        .font(.system(size: Col.getTextSize(geometry)))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0.5)
                        .shadow(color: .black, radius: 0.5)
                        .shadow(color: .black, radius: 0.5)
                        .shadow(color: .black, radius: 0.5)
                        .shadow(color: .black, radius: 0.5)
                    Spacer()
                    
                }
                Spacer().frame(height: Col.getPaddingSize(geometry))
            }
        }.background(isHighlighted ? Color.red.opacity(0.3) : Color.clear)

    }
}

struct Row: View {
    var index: Int;
    var highlightedCell: Int;
    var cols: Int;
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...cols, id: \.self) { columnNumber in
                 Col(
                     number: index * cols + columnNumber,
                     isHighlighted: index * cols + columnNumber == highlightedCell
                 ).border(Color.red, width: 1)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var grid: GridManager
        
    var body: some View {
        VStack(spacing: 0) {
            // this is the insane way to do `(1...grid.rows).reversed()`
            ForEach(0..<(grid.rows)) { rowNumber in
                Row(index: (grid.rows - rowNumber) - 1, highlightedCell: grid.highlightedCell, cols: grid.cols)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.clear)
    }
}
