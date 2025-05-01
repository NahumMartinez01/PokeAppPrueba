//
//  PokemonListModel.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import Foundation
import CoreData


struct PokemonListBaseResponse : Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonListModel]?
}

struct PokemonListModel : Codable, Identifiable {
    var id: String {name ?? ""}
    let name: String?
    let url: String?
}

struct PokemonDetailModel: Codable, Identifiable {
    let id: Int
    let name: String
    let sprites: SpriteImages
    let types: [PokemonTypeSlot]
}

struct SpriteImages: Codable {
    let front_default: String?
}

struct PokemonTypeSlot: Codable, Identifiable {
    var id: Int {slot}
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}



extension PokemonDetailModel {
    func toEntity(context: NSManagedObjectContext) -> PokemonDetailEntity {
        let entity = PokemonDetailEntity(context: context)
        entity.id = Int64(self.id)
        entity.name = self.name
        entity.spritesURL = self.sprites.front_default
        for typeSlot in types {
            let typeEntity = PokemonTypeEntity(context: context)
            typeEntity.slot = Int64(typeSlot.slot)
            typeEntity.name = typeSlot.type.name
        }

        return entity
    }
}
