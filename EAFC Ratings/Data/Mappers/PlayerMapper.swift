//
//  PlayerMapper.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

// MARK: - Mapper between DTO and Domain

struct PlayerMapper {

    static func toDomain(_ dto: PlayerDTO) -> Player {
        Player(
            id: dto.id,
            rank: dto.rank,
            firstName: dto.firstName,
            lastName: dto.lastName,
            commonName: dto.commonName ?? "",
            birthdate: parseBirthdate(dto.birthdate),
            height: dto.height,
            weight: dto.weight,
            overallRating: dto.overallRating,
            position: toDomain(dto.position),
            alternatePositions: dto.alternatePositions?.map(toDomain) ?? [],
            avatarUrl: dto.avatarUrl,
            shieldUrl: dto.shieldUrl,
            team: toDomain(dto.team),
            nationality: toDomain(dto.nationality),
            skillMoves: dto.skillMoves,
            weakFootAbility: dto.weakFootAbility,
            preferredFoot: FootPreference(rawValue: dto.preferredFoot) ?? .right,
            stats: toDomain(dto.stats),
            playerAbilities: dto.playerAbilities?.map(toDomain) ?? []
        )
    }

    private static func toDomain(_ dto: PositionDTO) -> Position {
        Position(
            id: dto.id,
            shortLabel: dto.shortLabel,
            label: dto.label
        )
    }

    private static func toDomain(_ dto: TeamDTO) -> Team {
        Team(
            id: dto.id,
            label: dto.label,
            imageUrl: dto.imageUrl
        )
    }

    private static func toDomain(_ dto: NationalityDTO) -> Nationality {
        Nationality(
            id: dto.id,
            label: dto.label,
            imageUrl: dto.imageUrl
        )
    }

    private static func toDomain(_ stats: [String: StatDTO]) -> PlayerStats {
        let statDict = Dictionary(uniqueKeysWithValues: stats.map { ($0.key, $0.value.value) })

        return PlayerStats(
            pace: statDict["pac"] ?? 0,
            shooting: statDict["sho"] ?? 0,
            passing: statDict["pas"] ?? 0,
            dribbling: statDict["dri"] ?? 0,
            defending: statDict["def"] ?? 0,
            physicality: statDict["phy"] ?? 0,
            diving: statDict["div"],
            handling: statDict["han"],
            kicking: statDict["kic"],
            positioning: statDict["pos"],
            reflexes: statDict["ref"],
            acceleration: statDict["acceleration"] ?? 0,
            sprintSpeed: statDict["sprintSpeed"] ?? 0,
            positioningAttack: statDict["positioning"] ?? 0,
            finishing: statDict["finishing"] ?? 0,
            shotPower: statDict["shotPower"] ?? 0,
            longShots: statDict["longShots"] ?? 0,
            volleys: statDict["volleys"] ?? 0,
            penalties: statDict["penalties"] ?? 0,
            vision: statDict["vision"] ?? 0,
            crossing: statDict["crossing"] ?? 0,
            freeKickAccuracy: statDict["freeKickAccuracy"] ?? 0,
            shortPassing: statDict["shortPassing"] ?? 0,
            longPassing: statDict["longPassing"] ?? 0,
            curve: statDict["curve"] ?? 0,
            agility: statDict["agility"] ?? 0,
            balance: statDict["balance"] ?? 0,
            reactions: statDict["reactions"] ?? 0,
            ballControl: statDict["ballControl"] ?? 0,
            dribblingDetail: statDict["dribbling"] ?? 0,
            composure: statDict["composure"] ?? 0,
            interceptions: statDict["interceptions"] ?? 0,
            headingAccuracy: statDict["headingAccuracy"] ?? 0,
            defAwareness: statDict["defAwareness"] ?? 0,
            standingTackle: statDict["standingTackle"] ?? 0,
            slidingTackle: statDict["slidingTackle"] ?? 0,
            jumping: statDict["jumping"] ?? 0,
            stamina: statDict["stamina"] ?? 0,
            strength: statDict["strength"] ?? 0,
            aggression: statDict["aggression"] ?? 0
        )
    }

    private static func toDomain(_ dto: PlayerAbilityDTO) -> PlayerAbility {
        PlayerAbility(
            id: dto.id,
            label: dto.label,
            imageURL: dto.imageURL,
            description: dto.description,
            abilityType: toDomain(dto.type)
        )
    }

    private static func toDomain(_ dto: AbilityTypeDTO) -> AbilityType {
        AbilityType(
            id: dto.id,
            label: dto.label)
    }

    private static func parseBirthdate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.date(from: dateString)
    }
}
