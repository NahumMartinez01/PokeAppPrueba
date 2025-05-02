//
//  PokemonService.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import Foundation
import BackgroundTasks
import CoreData

class PokemonService {
    static let shared = PokemonService()

    func updatePokemonsInBackground(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !UserDefaults.standard.bool(forKey: "DidDownloadPokemons") else {
            print("✅ Pokémons ya fueron descargados anteriormente")
            completion(.success(()))
            return
        }

        Task {
            do {
                // Obtener la lista de Pokémon básicos
                let response = try await AppServices.shared.fetchRequest(
                    url: AppServicesUtils.PokemonURLs.getPokemonList(),
                    method: AppServicesK.methodRequest.GET.rawValue,
                    headers: nil,
                    body: nil,
                    responseType: PokemonListBaseResponse.self
                )
                
                let pokemons = response.results ?? []
                
                var detailedPokemons: [PokemonDetailModel] = []
                
                await withTaskGroup(of: Void.self) { group in
                    for pokemon in pokemons {
                        group.addTask {
                            if let detail = await self.getPokemonDetail(url: pokemon.url ?? "") {
                                detailedPokemons.append(detail)
                            }
                        }
                    }
                }
                
                await self.savePokemonsToCoreData(pokemons: detailedPokemons)
                
                UserDefaults.standard.set(true, forKey: "DidDownloadPokemons")
                completion(.success(()))
            } catch {
                print("Un error ha ocurrido al obtener los Pokémon:", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    private func getPokemonDetail(url: String) async -> PokemonDetailModel? {
        do {
            let response = try await AppServices.shared.fetchRequest(
                url: url,
                method: AppServicesK.methodRequest.GET.rawValue,
                headers: nil,
                body: nil,
                responseType: PokemonDetailModel.self
            )
            return response // Devuelve el detalle del Pokémon
        } catch {
            print("Error al obtener el detalle para \(url):", error.localizedDescription)
            return nil // Si hay un error, devuelve nil
        }
    }


    private func savePokemonsToCoreData(pokemons: [PokemonDetailModel]) async {
            let viewContext = PersistenceController.shared.container.viewContext
            
            for pokemon in pokemons {
                let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(pokemon.id))
                
                do {
                    if let existingPokemon = try viewContext.fetch(fetchRequest).first {
                        existingPokemon.name = pokemon.name
                        existingPokemon.spritesURL = pokemon.sprites.front_default
                        // Aquí deberías limpiar los tipos y agregar los nuevos
                        if let existingTypes = existingPokemon.types as? Set<PokemonTypeEntity> {
                            for type in existingTypes {
                                viewContext.delete(type)
                            }
                        }
                        
                        for typeSlot in pokemon.types {
                            let typeEntity = PokemonTypeEntity(context: viewContext)
                            typeEntity.slot = Int64(typeSlot.slot)
                            typeEntity.name = typeSlot.type.name
                            existingPokemon.addToTypes(typeEntity)
                        }
                    } else {
                        let pokemonEntity = PokemonDetailEntity(context: viewContext)
                        pokemonEntity.id = Int64(pokemon.id)
                        pokemonEntity.name = pokemon.name
                        pokemonEntity.spritesURL = pokemon.sprites.front_default
                        
                        for typeSlot in pokemon.types {
                            let typeEntity = PokemonTypeEntity(context: viewContext)
                            typeEntity.slot = Int64(typeSlot.slot)
                            typeEntity.name = typeSlot.type.name
                            pokemonEntity.addToTypes(typeEntity)
                        }
                    }
                } catch {
                    print("Error processing Pokémon \(pokemon.name): \(error.localizedDescription)")
                }
            }

            do {
                try viewContext.save()
                PersistenceController.shared.saveContext()
            } catch {
                print("Error saving to Core Data: \(error.localizedDescription)")
            }
        }
}

func handleAppRefreshTask(task: BGAppRefreshTask) {
    task.expirationHandler = {
        task.setTaskCompleted(success: false)
    }

    PokemonService.shared.updatePokemonsInBackground { result in
        switch result {
        case .success:
            print("Pokémon actualizados en segundo plano.")
            task.setTaskCompleted(success: true)
        case .failure(let error):
            print("Error al obtener los Pokémon en segundo plano: \(error.localizedDescription)")
            task.setTaskCompleted(success: false)
        }
    }
    
}
