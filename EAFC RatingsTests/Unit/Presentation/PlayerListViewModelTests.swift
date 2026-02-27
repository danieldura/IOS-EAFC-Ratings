//
//  PlayerListViewModelTests.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings
import Testing

@MainActor
@Suite("PlayerListViewModel Tests")
struct PlayerListViewModelTests {

    // MARK: - Test Initial State

    @Test("Initial state should be empty")
    func testInitialState() async {
        let mockUseCase = MockGetPlayersUseCase()
        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        #expect(viewModel.state.players.isEmpty)
        #expect(viewModel.state.displayedPlayers.isEmpty)
        #expect(!viewModel.state.isLoading)
        #expect(viewModel.state.error == nil)
        #expect(viewModel.state.searchText.isEmpty)
        #expect(viewModel.state.currentPage == 0)
    }

    // MARK: - Test Load Players Success

    @Test("Load players successfully")
    func testLoadPlayersSuccess() async {
        let mockUseCase = MockGetPlayersUseCase()
        mockUseCase.mockPlayers = Player.createMockPlayers(count: 50)

        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        viewModel.handle(.loadInitialPlayers)

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state.players.count == 50)
        #expect(viewModel.state.displayedPlayers.count == 25) // First page
        #expect(!viewModel.state.isLoading)
        #expect(viewModel.state.error == nil)
        #expect(mockUseCase.executeCallCount == 1)
    }

    // MARK: - Test Load Players Failure

    @Test("Load players with error")
    func testLoadPlayersFailure() async {
        let mockUseCase = MockGetPlayersUseCase()
        mockUseCase.shouldFail = true

        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        viewModel.handle(.loadInitialPlayers)

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state.players.isEmpty)
        #expect(viewModel.state.error != nil)
        #expect(!viewModel.state.isLoading)
    }

    // MARK: - Test Pagination

    @Test("Load more players pagination")
    func testPagination() async {
        let mockUseCase = MockGetPlayersUseCase()
        mockUseCase.mockPlayers = Player.createMockPlayers(count: 100)

        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        // Load initial
        viewModel.handle(.loadInitialPlayers)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state.displayedPlayers.count == 25)
        #expect(viewModel.state.hasMorePages)

        // Load more
        viewModel.handle(.loadMorePlayers)
        try? await Task.sleep(nanoseconds: 500_000_000)

        #expect(viewModel.state.displayedPlayers.count == 50)
        #expect(viewModel.state.hasMorePages)
    }

    // MARK: - Test Search

    @Test("Search filters players correctly")
    func testSearch() async {
        let mockUseCase = MockGetPlayersUseCase()
        mockUseCase.mockPlayers = Player.createMockPlayers(count: 10)

        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        // Load initial
        viewModel.handle(.loadInitialPlayers)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.state.displayedPlayers.count == 10)

        // Search
        viewModel.handle(.search("Player 1"))
        try? await Task.sleep(nanoseconds: 400_000_000) // Wait for debounce

        #expect(viewModel.state.searchText == "Player 1")
        #expect(viewModel.state.players.count == 1)
    }

    // MARK: - Test Refresh

    @Test("Refresh reloads players")
    func testRefresh() async {
        let mockUseCase = MockGetPlayersUseCase()
        mockUseCase.mockPlayers = Player.createMockPlayers(count: 30)

        let viewModel = PlayerListViewModel(getPlayersUseCase: mockUseCase)

        // Initial load
        viewModel.handle(.loadInitialPlayers)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(mockUseCase.executeCallCount == 1)

        // Refresh
        viewModel.handle(.refresh)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(mockUseCase.executeCallCount == 2)
        #expect(viewModel.state.players.count == 30)
    }
}
