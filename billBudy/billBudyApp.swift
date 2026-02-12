//
//  billBudyApp.swift
//  billBudy
//
//  Created by Mahamed Mahad on 11/02/2026.
//

import SwiftUI

@main
struct billBudyApp: App {
    @State private var viewModel = CalculatorViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
