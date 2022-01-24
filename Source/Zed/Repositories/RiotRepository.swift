//
//  NewsWebRepository.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/6/22.
//

import Combine
import LeagueAPI

enum LeagueError {
    case error(String?)
}

extension LeagueError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error(let error):
            return error ?? "No error description"
        }
    }
}

protocol RiotRepositoryProtocol: AnyObject {
    func getAllChampionIds() -> Future<[ChampionId], LeagueError>
    func getChampionDetails(championId: ChampionId) -> Future<ChampionDetails, LeagueError>
}

final class RiotRepository: RiotRepositoryProtocol {
    let league = LeagueAPI(APIToken: "<YOUR RIOT API KEY>")
    
    func getAllChampionIds() -> Future<[ChampionId], LeagueError> {
        return Future<[ChampionId], LeagueError> { promise in
            self.league.lolAPI.getAllChampionIds() { (championsIds, error) in
                if let championsIds = championsIds {
                    promise(.success(championsIds))
                } else {
                    promise(.failure(LeagueError.error(error)))
                }
            }
        }
    }
    
    func getChampionDetails(championId: ChampionId) -> Future<ChampionDetails, LeagueError> {
        return Future<ChampionDetails, LeagueError> { promise in
            self.league.lolAPI.getChampionDetails(by: championId) { (champion, error) in
                if let champion = champion {
                    promise(.success(champion))
                } else {
                    promise(.failure(LeagueError.error(error)))
                }
            }
        }
    }
}
