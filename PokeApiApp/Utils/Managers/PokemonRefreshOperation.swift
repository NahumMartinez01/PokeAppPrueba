//
//  PokemonRefreshOperation.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation

final class PokemonRefreshOperation: Operation, @unchecked Sendable {
    override func main() {
        let backgroundContext = PersistenceController.shared.backgroundContext
        let viewModel = PokemonMainViewModel(viewContext: backgroundContext)
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            await viewModel.getPokemonsList()
            NotificationManager.shared.scheduleNotification(
                title: "Pokédex actualizada",
                body: "Se agregaron nuevos Pokémon a la lista."
            )
            semaphore.signal()
        }
     
        semaphore.wait()
    }
}

