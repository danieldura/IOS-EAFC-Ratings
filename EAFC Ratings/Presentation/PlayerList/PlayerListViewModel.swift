//
//  PlayerListViewModel.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation
import Combine

@MainActor
final class PlayerListViewModel: ObservableObject {

    // MARK: - Published State
    @Published private(set) var state = PlayerListState()

    // MARK: - Dependencies
    private let getPlayersUseCase: GetPlayersUseCaseProtocol

    // MARK: - Private Properties
    private var allPlayers: [Player] = []
    private var cancellables = Set<AnyCancellable>()

    init(getPlayersUseCase: GetPlayersUseCaseProtocol) {
        self.getPlayersUseCase = getPlayersUseCase
        setupSearchDebounce()
    }

    // MARK: - Intent Handler
    func handle(_ intent: PlayerListIntent) {
        switch intent {
        case .loadInitialPlayers:
            loadInitialPlayers()
        case .loadMorePlayers:
            loadMorePlayers()
        case .refresh:
            refresh()
        case .search(let text):
            updateSearchText(text)
        case .retry:
            retry()
        }
    }

    // MARK: - Private Methods

    private func loadInitialPlayers() {
        guard !state.isLoading else { return }

        state.isLoading = true
        state.error = nil

        Task {
            do {
                let players = try await getPlayersUseCase.execute(forceRefresh: false)
                allPlayers = players
                state.players = players
                state.currentPage = 0
                updateDisplayedPlayers()
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }

    private func loadMorePlayers() {
        guard !state.isLoadingMore && state.hasMorePages && !state.isLoading else { return }

        state.isLoadingMore = true

        Task {
            // Simulate a small delay for better UX
            try? await Task.sleep(nanoseconds: 300_000_000)

            state.currentPage += 1
            updateDisplayedPlayers()
            state.isLoadingMore = false
        }
    }

    private func refresh() {
        state.isLoading = true
        state.error = nil

        Task {
            do {
                let players = try await getPlayersUseCase.execute(forceRefresh: true)
                allPlayers = players
                state.players = players
                state.currentPage = 0
                updateDisplayedPlayers()
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }

    private func retry() {
        loadInitialPlayers()
    }

    private func updateSearchText(_ text: String) {
        state.searchText = text
    }

    private func setupSearchDebounce() {
        $state
            .map(\.searchText)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ searchText: String) {
        if searchText.isEmpty {
            state.players = allPlayers
        } else {
            state.players = allPlayers.filter { player in
                player.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }

        state.currentPage = 0
        updateDisplayedPlayers()
    }

    private func updateDisplayedPlayers() {
        let endIndex = min((state.currentPage + 1) * PlayerListState.pageSize, state.players.count)
        state.displayedPlayers = Array(state.players.prefix(endIndex))
        state.hasMorePages = endIndex < state.players.count
    }
}
