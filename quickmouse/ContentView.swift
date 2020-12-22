import SwiftUI

struct Col: View {
    var number: Int;
    
    var body: some View {
        GeometryReader { geometry in
            Text(String(self.number))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: geometry.size.width > 40 ? 30 : 15))
        }
    }
}

struct Row: View {
    var index: Int;
    var activeCol: Int;
    
    var body: some View {
        HStack(spacing: 0) {
            Col(number: index * 3 + 1).border(Color.red, width: 1).background(self.activeCol == 1 ? Color.red.opacity(0.3) : Color.clear)
            Col(number: index * 3 + 2).border(Color.red, width: 1).background(self.activeCol == 2 ? Color.red.opacity(0.3) : Color.clear)
            Col(number: index * 3 + 3).border(Color.red, width: 1).background(self.activeCol == 0 ? Color.red.opacity(0.3) : Color.clear)
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var grid: GridManager
        
    var body: some View {
        VStack(spacing: 0) {
            Row(index: 2, activeCol: grid.highlightedCell >= 7 ? grid.highlightedCell % 3 : -1)
            Row(index: 1, activeCol: (grid.highlightedCell > 3 && grid.highlightedCell < 7) ? grid.highlightedCell % 3 : -1)
            Row(index: 0, activeCol: grid.highlightedCell < 4 ? grid.highlightedCell % 3 : -1)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.clear)
    }
}
