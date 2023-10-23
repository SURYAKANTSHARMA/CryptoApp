//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Surya on 22/10/23.
//

import CoreData

class PortfolioServiceContainer {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities = [PortfolioEntity]()
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        self.container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
            self.getPortfolio()
         }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching porfolio \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error Saving coin \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
    private func update(entity: PortfolioEntity,
                        amount: Double) {
        
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    //MARK: - Public function -> CRUD
    func updatePortfolio(coin: CoinModel,  amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
}

