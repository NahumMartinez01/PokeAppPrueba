//
//  PokerMapper.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation
import CoreData

//MARK: MAPPER PARA OBTENCIÓN Y CONVERSIÓN DE DATA
struct PokemonMapper {
    static func toModel(from entity: PokemonDetailEntity) -> PokemonDetailModel {
        PokemonDetailModel(
            id: Int(entity.id),
            name: entity.name ?? "Unknown",
            sprites: SpriteImages(front_default: entity.spritesURL),
            types: (entity.types as? Set<PokemonTypeEntity>)?
                .sorted { $0.slot < $1.slot }
                .map { type in
                    PokemonTypeSlot(
                        slot: Int(type.slot),
                        type: PokemonType(name: type.name ?? "unknown")
                    )
                } ?? []
        )
    }
    
    static func toEntity(from model: PokemonDetailModel, context: NSManagedObjectContext) -> PokemonDetailEntity {
        let pokemonEntity = PokemonDetailEntity(context: context)
        pokemonEntity.id = Int64(model.id)
        pokemonEntity.name = model.name
        pokemonEntity.spritesURL = model.sprites.front_default
        
        for typeSlot in model.types {
            let typeEntity = PokemonTypeEntity(context: context)
            typeEntity.slot = Int64(typeSlot.slot)
            typeEntity.name = typeSlot.type.name
            pokemonEntity.addToTypes(typeEntity)
        }
        
        return pokemonEntity
    }
}
