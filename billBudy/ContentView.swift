//
//  ContentView.swift
//  billBudy
//
//  Created by Mahamed Mahad on 11/02/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        CalculatorView()
    }
}

#Preview {
    ContentView()
        .environment(CalculatorViewModel())
}
