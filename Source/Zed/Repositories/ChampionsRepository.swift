//
//  ChampionRepository.swift
//  Zed
//
//  Created by Pedro Fernandez on 1/20/22.
//

import Foundation
import LeagueAPI
import CoreData

protocol ChampionsRepositoryProtocol: AnyObject {
    func createChampion(champion: ChampionDetails)
    func getAllChampions() -> [Champion]
    func updateChampion(champion: ChampionDetails)
    func deleteChampion(_ champion: Champion)
    func deleteAllChampions()
}

final class ChampionsRepository: ChampionsRepositoryProtocol {
    let viewContext = PersistenceController.shared.viewContext
    
    func createChampion(champion: ChampionDetails) {
        let newChampion = Champion(context: viewContext)
        newChampion.id = Int16(champion.championId.value)
        newChampion.date = Date()
        newChampion.name = champion.name
        newChampion.title = champion.title
        saveContext()
    }
    
    func getAllChampions() -> [Champion] {
        let request: NSFetchRequest<Champion> = Champion.fetchRequest()
        let sort: NSSortDescriptor = NSSortDescriptor(keyPath: \Champion.date, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func updateChampion(champion: ChampionDetails) {
        // No-op
    }
    
    func deleteChampion(_ champion: Champion) {
        viewContext.delete(champion)
        saveContext()
    }
    
    func deleteAllChampions() {
        let storeCoordinator = PersistenceController.shared.container.persistentStoreCoordinator
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Champion")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try storeCoordinator.execute(deleteRequest, with: viewContext)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveContext() {
        PersistenceController.shared.save()
    }
}
