//
//  EAFC_RatingsApp.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import SwiftUI
import SwiftData

@main
struct EAFCRatingsApp: App {
    private let dependencies = DependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            PlayerListView(viewModel: dependencies.makePlayerListViewModel())
                .environment(\.dependencies, dependencies)
                .modelContainer(dependencies.modelContainer)
        }
    }
}
