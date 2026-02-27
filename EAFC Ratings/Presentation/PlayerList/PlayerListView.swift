//
//  PlayerListView.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import SwiftUI

struct PlayerListView: View {

    @StateObject private var viewModel: PlayerListViewModel

    init(viewModel: PlayerListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
            }
            .navigationTitle("EAFC Ratings")
            .searchable(
                text: Binding(
                    get: { viewModel.state.searchText },
                    set: { viewModel.handle(.search($0)) }
                ),
                prompt: "Buscar jugador..."
            )
        }
        .onAppear {
            if viewModel.state.displayedPlayers.isEmpty && !viewModel.state.isLoading {
                viewModel.handle(.loadInitialPlayers)
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.state.isLoading && viewModel.state.displayedPlayers.isEmpty {
            loadingView
        } else if viewModel.state.shouldShowError {
            errorView
        } else if viewModel.state.isEmpty {
            emptyView
        } else {
            playerListView
        }
    }

    private var playerListView: some View {
        List {
            ForEach(viewModel.state.displayedPlayers) { player in
                NavigationLink(value: player) {
                    PlayerRowView(player: player)
                }
                .onAppear {
                    if player.id == viewModel.state.displayedPlayers.last?.id {
                        viewModel.handle(.loadMorePlayers)
                    }
                }
            }

            if viewModel.state.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.handle(.refresh)
        }
        .navigationDestination(for: Player.self) { player in
            PlayerDetailView(player: player)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Cargando jugadores...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)

            Text("Error al cargar")
                .font(.headline)

            if let error = viewModel.state.error {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button {
                viewModel.handle(.retry)
            } label: {
                Text("Reintentar")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No se encontraron jugadores")
                .font(.headline)

            Text("Intenta con otra búsqueda")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Player Row View

struct PlayerRowView: View {
    let player: Player

    var body: some View {
        HStack(spacing: 12) {
            // Avatar Image
            AsyncImage(url: URL(string: player.avatarUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            // Player Info
            VStack(alignment: .leading, spacing: 4) {
                Text(player.displayName)
                    .font(.headline)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(player.position.shortLabel)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .cornerRadius(4)

                    Text(player.team.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Rating Badge
            VStack(spacing: 2) {
                Text("\(player.overallRating)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("OVR")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(width: 50, height: 50)
            .background(ratingColor(for: player.overallRating))
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }

    private func ratingColor(for rating: Int) -> Color {
        switch rating {
        case 90...: return Color(red: 0.8, green: 0.6, blue: 0.0) // Gold
        case 85..<90: return Color(red: 0.9, green: 0.3, blue: 0.3) // Red
        case 80..<85: return Color(red: 0.3, green: 0.6, blue: 0.9) // Blue
        default: return Color.gray
        }
    }
}
