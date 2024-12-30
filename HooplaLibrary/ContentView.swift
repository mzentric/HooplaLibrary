//
//  ContentView.swift
//  HooplaLibrary
//
//  Created by maria on 12/29/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MovieGridView()
                .navigationTitle("Movies")
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
