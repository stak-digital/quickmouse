//
//  ContentView.swift
//  quickmouse
//
//  Created by Bryce Hanscomb on 3/4/20.
//  Copyright © 2020 STAK Digital. All rights reserved.
//

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
    
    var body: some View {
        HStack(spacing: 0) {
            Col(number: index * 3 + 1).border(Color.green, width: 1)
            Col(number: index * 3 + 2).border(Color.red, width: 1)
            Col(number: index * 3 + 3).border(Color.blue, width: 1)
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Row(index: 2)
            Row(index: 1)
            Row(index: 0)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.clear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }.background(Color.red)
    }
}
