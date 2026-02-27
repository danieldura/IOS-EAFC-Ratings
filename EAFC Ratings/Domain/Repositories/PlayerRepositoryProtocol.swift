//
//  PlayerRepositoryProtocol.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

protocol PlayerRepositoryProtocol {
    func getPlayers(forceRefresh: Bool) async throws -> [Player]
    func getPlayer(byId id: Int) async throws -> Player?
}
