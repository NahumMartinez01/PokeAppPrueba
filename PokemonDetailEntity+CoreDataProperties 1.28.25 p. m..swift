//
//  PokemonDetailEntity+CoreDataProperties.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//
//

import Foundation
import CoreData


extension PokemonDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonDetailEntity> {
        return NSFetchRequest<PokemonDetailEntity>(entityName: "PokemonDetailEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var frontImageUrl: String?
    @NSManaged public var pokemon: PokemonTypeEntity?

}

extension PokemonDetailEntity : Identifiable {

}
