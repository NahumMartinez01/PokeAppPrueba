//
//  PokeApiAppTests.swift
//  PokeApiAppTests
//
//  Created by Nahum Martinez on 29/4/25.
//

import XCTest
import CoreData
@testable import PokeApiApp

final class PokeApiAppTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }

    override func tearDownWithError() throws {
        context = nil
        persistenceController = nil
    }

    func testSavingAndFetchingFivePokemons() throws {
        let pokemonsData = [
            (id: 1, name: "bulbasaur", sprite: "https://pokeapi.co/sprites/1.png", type: "grass"),
            (id: 2, name: "ivysaur", sprite: "https://pokeapi.co/sprites/2.png", type: "grass"),
            (id: 3, name: "venusaur", sprite: "https://pokeapi.co/sprites/3.png", type: "grass"),
            (id: 4, name: "charmander", sprite: "https://pokeapi.co/sprites/4.png", type: "fire"),
            (id: 5, name: "squirtle", sprite: "https://pokeapi.co/sprites/5.png", type: "water")
        ]
        
        for data in pokemonsData {
            let pokemon = PokemonDetailEntity(context: context)
            pokemon.id = Int64(data.id)
            pokemon.name = data.name
            pokemon.spritesURL = data.sprite

            let type = PokemonTypeEntity(context: context)
            type.name = data.type
            type.slot = 1
            pokemon.addToTypes(type)
        }

        try context.save()

        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 5, "Debe haber 5 Pokémon guardados")

        for data in pokemonsData {
            let match = results.first { $0.id == data.id }
            XCTAssertNotNil(match, "Debe existir el Pokémon con ID \(data.id)")
            XCTAssertEqual(match?.name, data.name)
            XCTAssertEqual(match?.spritesURL, data.sprite)

            let types = match?.types as? Set<PokemonTypeEntity>
            XCTAssertEqual(types?.first?.name, data.type)
            XCTAssertEqual(types?.first?.slot, 1)
        }
    }

}
