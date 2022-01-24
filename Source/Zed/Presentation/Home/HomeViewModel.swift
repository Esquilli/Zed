//
//  MyBackendModel.swift
//  Stripy
//
//  Created by Pedro Fernandez on 1/18/22.
//

import Combine
import SwiftUI
import LeagueAPI

class HomeViewModel: ObservableObject {
    @Published var champions = [Champion]()
    
    private var cancellables = Set<AnyCancellable>()
    private let riotRepository: RiotRepositoryProtocol
    private let championsRepository: ChampionsRepositoryProtocol
    private var allChampionsIds = [ChampionId]()
    
    init(riotRepository: RiotRepositoryProtocol, championsRepository: ChampionsRepositoryProtocol) {
        self.riotRepository = riotRepository
        self.championsRepository = championsRepository
    }
    
    func load() {
        print("List")
        self.getAllChampionIds()
        self.champions = championsRepository.getAllChampions()
    }
    
    private func getAllChampionIds() {
        riotRepository.getAllChampionIds()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Got random champion")
                case .failure(let error):
                    print("Something happened: ", error)
                }
                
            } receiveValue: { [weak self] data in
                self?.allChampionsIds = data
            }
            .store(in: &cancellables)
    }

    func getRandomChampion() {
        guard let championId = allChampionsIds.randomElement() else { return }
        
        riotRepository.getChampionDetails(championId: championId)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                print("Got random champion")
            case .failure(let error):
                print("Something happened: ", error)
            }
            
        } receiveValue: { [weak self] data in
            self?.championsRepository.createChampion(champion: data)
            self?.reloadList()
        }
        .store(in: &cancellables)
    }
    
    func deleteChampion(at offsets: IndexSet) {
        for index in offsets {
            championsRepository.deleteChampion(champions[index])
            champions.remove(at: index)
        }
        reloadList()
    }
    
    func clearList() {
        championsRepository.deleteAllChampions()
        champions = []
    }
    
    func reloadList() {
        champions = championsRepository.getAllChampions()
    }
}
