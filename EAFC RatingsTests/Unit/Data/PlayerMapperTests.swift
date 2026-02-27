//
//  PlayerMapperTests.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Testing
import Foundation
@testable import EAFC_Ratings

struct PlayerMapperTests {

    @Test("Mapper converts DTO to Domain correctly")
    func testMapperConversion() throws {
        let dto = PlayerDTO.mock

        let player = PlayerMapper.toDomain(dto)

        #expect(player.id == 123)
        #expect(player.displayName == "L. Messi")
        #expect(player.overallRating == 93)
        #expect(player.stats.agility == 92)
        #expect(player.preferredFoot == .left)
    }
}
