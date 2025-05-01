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

    func testSavingAndFetchingPokemon() throws {
        let pokemon = PokemonDetailEntity(context: context)
        pokemon.id = 1
        pokemon.name = "bulbasaur"
        pokemon.spritesURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"

        let type = PokemonTypeEntity(context: context)
        type.name = "grass"
        type.slot = 1
        
        pokemon.addToTypes(type)
        try context.save()

        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        let results = try context.fetch(fetchRequest)

        XCTAssertEqual(results.count, 1, "Debe haber un Pokémon guardado")
        XCTAssertEqual(results.first?.name, "bulbasaur")
        XCTAssertEqual(results.first?.spritesURL, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")

        let types = results.first?.types as? Set<PokemonTypeEntity>
        XCTAssertEqual(types?.first?.name, "grass")
        XCTAssertEqual(types?.first?.slot, 1)
    }
}
