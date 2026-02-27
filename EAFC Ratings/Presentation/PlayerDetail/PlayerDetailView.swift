//
//  PlayerDetailView.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import SwiftUI

struct PlayerDetailView: View {
    let player: Player

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24, pinnedViews: []) {
                headerSection
                basicInfoSection
                statsSection
                detailedStatsSection
                abilitiesSection
            }
            .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(player.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: player.avatarUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(ratingColor(for: player.overallRating), lineWidth: 4)
                        )
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(spacing: 8) {
                Text(player.displayName)
                    .font(.title)
                    .fontWeight(.bold)

                HStack(spacing: 16) {
                    Label(player.position.label, systemImage: "figure.run")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Label(player.team.label, systemImage: "sportscourt")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Overall Rating Badge
                Text("\(player.overallRating)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
                    .background(ratingColor(for: player.overallRating))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 3)
                    )
                    .shadow(radius: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // MARK: - Basic Info Section

    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información Básica")
                .font(.title3)
                .fontWeight(.bold)

            Divider()

            InfoRow(label: "Nombre Completo", value: "\(player.firstName) \(player.lastName)")
            InfoRow(label: "Nacionalidad", value: player.nationality.label)
            InfoRow(label: "Altura", value: "\(player.height) cm")
            InfoRow(label: "Peso", value: "\(player.weight) kg")
            InfoRow(label: "Pie Preferido", value: player.preferredFoot.displayName)
            InfoRow(label: "Regate", value: String(repeating: "⭐️", count: player.skillMoves))
            InfoRow(label: "Pierna Mala", value: String(repeating: "⭐️", count: player.weakFootAbility))

            if let birthdate = player.birthdate {
                InfoRow(label: "Fecha de Nacimiento", value: formatDate(birthdate))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Main Stats Section

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estadísticas Principales")
                .font(.title3)
                .fontWeight(.bold)

            Divider()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(label: "Ritmo", value: player.stats.pace, color: .green)
                StatCard(label: "Tiro", value: player.stats.shooting, color: .red)
                StatCard(label: "Pase", value: player.stats.passing, color: .blue)
                StatCard(label: "Regate", value: player.stats.dribbling, color: .purple)
                StatCard(label: "Defensa", value: player.stats.defending, color: .orange)
                StatCard(label: "Físico", value: player.stats.physicality, color: .pink)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Detailed Stats Section

    private var detailedStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estadísticas Detalladas")
                .font(.title3)
                .fontWeight(.bold)

            Divider()

            VStack(spacing: 8) {
                StatBar(label: "Aceleración", value: player.stats.acceleration)
                StatBar(label: "Velocidad Sprint", value: player.stats.sprintSpeed)
                StatBar(label: "Finalización", value: player.stats.finishing)
                StatBar(label: "Potencia de Tiro", value: player.stats.shotPower)
                StatBar(label: "Tiros Lejanos", value: player.stats.longShots)
                StatBar(label: "Visión", value: player.stats.vision)
                StatBar(label: "Pase Corto", value: player.stats.shortPassing)
                StatBar(label: "Pase Largo", value: player.stats.longPassing)
                StatBar(label: "Control de Balón", value: player.stats.ballControl)
                StatBar(label: "Agilidad", value: player.stats.agility)
                StatBar(label: "Equilibrio", value: player.stats.balance)
                StatBar(label: "Reacciones", value: player.stats.reactions)
                StatBar(label: "Entrada de Pie", value: player.stats.standingTackle)
                StatBar(label: "Entrada Deslizante", value: player.stats.slidingTackle)
                StatBar(label: "Resistencia", value: player.stats.stamina)
                StatBar(label: "Fuerza", value: player.stats.strength)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Abilities Section

    private var abilitiesSection: some View {
        Group {
            if !player.playerAbilities.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Habilidades Especiales")
                        .font(.title3)
                        .fontWeight(.bold)

                    Divider()

                    ForEach(player.playerAbilities) { ability in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(ability.description)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Helper Methods

    private func ratingColor(for rating: Int) -> Color {
        switch rating {
        case 90...: return Color(red: 0.8, green: 0.6, blue: 0.0)
        case 85..<90: return Color(red: 0.9, green: 0.3, blue: 0.3)
        case 80..<85: return Color(red: 0.3, green: 0.6, blue: 0.9)
        default: return Color.gray
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}

struct StatCard: View {
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct StatBar: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.semibold)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(colorForValue(value))
                        .frame(width: geometry.size.width * CGFloat(value) / 100, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
    }

    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 80...: return .green
        case 60..<80: return .yellow
        default: return .red
        }
    }
}
