//
//  PokemonRepository.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation

import CoreData

protocol PokemonRepositoryProtocol {
    func fetchPokemons(searchText: String, filterType: FilterType, completion: @escaping (Result<[PokemonDetailModel], PokemonError>) -> Void)
    func savePokemons(_ pokemons: [PokemonDetailModel]) throws
    func deleteAllPokemons() throws
}

//MARK: REPOSITORY PARA GESTION DE OPERACIONES DE COREDATA
class PokemonRepository: PokemonRepositoryProtocol {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.viewContext = viewContext
    }
    
    func fetchPokemons(searchText: String, filterType: FilterType, completion: @escaping (Result<[PokemonDetailModel], PokemonError>) -> Void) {
        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        
        if !searchText.isEmpty {
            switch filterType {
            case .name:
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            case .type:
                fetchRequest.predicate = NSPredicate(format: "ANY types.name CONTAINS[cd] %@", searchText)
            case .id:
                if let id = Int64(searchText) {
                    fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
                }
            }
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            let pokemons = entities.map {PokemonMapper.toModel(from: $0)}
            completion(.success(pokemons))
        } catch {
            completion(.failure(.getCoreDataError(message: error.localizedDescription)))
        }
    }
    
    func savePokemons(_ pokemons: [PokemonDetailModel]) throws {
        for pokemon in pokemons {
            let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(pokemon.id))
            
            if let existingPokemon = try viewContext.fetch(fetchRequest).first {
                // Actualizar Pokémon existente
                existingPokemon.name = pokemon.name
                existingPokemon.spritesURL = pokemon.sprites.front_default
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
                // Crear nuevo Pokémon
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
        }
        
        try viewContext.save()
    }
    
    func deleteAllPokemons() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PokemonDetailEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(deleteRequest)
        try viewContext.save()
    }
}
