//
//  PlayerListState.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class PlayerListState {
    var players: [Player] = []
    
    var displayedPlayers: [Player] = []

    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var error: String?
    var searchText: String = ""
    var currentPage: Int = 0
    var hasMorePages: Bool = true

    static let pageSize = 25

    var isEmpty: Bool {
        !isLoading && displayedPlayers.isEmpty && error == nil
    }

    var shouldShowError: Bool {
        error != nil && !isLoading
    }

    init() {}
}

// MARK: - MVI Intent

enum PlayerListIntent {
    case loadInitialPlayers
    case loadMorePlayers
    case refresh
    case search(String)
    case retry
}
