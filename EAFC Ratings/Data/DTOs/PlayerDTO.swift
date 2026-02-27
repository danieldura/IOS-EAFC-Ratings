//
//  PlayerDTO.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

// MARK: - API Response DTOs

struct PlayersResponse: Codable {
    let items: [PlayerDTO]
}

struct PlayerDTO: Codable {
    let id: Int
    let rank: Int
    let firstName: String
    let lastName: String
    let commonName: String?
    let birthdate: String?
    let height: Int
    let weight: Int
    let overallRating: Int
    let position: PositionDTO
    let alternatePositions: [PositionDTO]?
    let avatarUrl: String?
    let shieldUrl: String?
    let team: TeamDTO
    let nationality: NationalityDTO
    let skillMoves: Int
    let weakFootAbility: Int
    let preferredFoot: Int
    let stats: [String: StatDTO]
    let playerAbilities: [PlayerAbilityDTO]?
}

struct PositionDTO: Codable {
    let id: String
    let shortLabel: String
    let label: String
}

struct TeamDTO: Codable {
    let id: Int
    let label: String
    let imageUrl: String?
}

struct NationalityDTO: Codable {
    let id: Int
    let label: String
    let imageUrl: String?
}

struct StatDTO: Codable {
    let value: Int
    let diff: Int?
}

struct PlayerAbilityDTO: Codable {
    let id: String
    let label: String
    let imageURL: String?
    let description: String
    let type: AbilityTypeDTO
}

struct AbilityTypeDTO: Codable {
    let id: String
    let label: String
}
