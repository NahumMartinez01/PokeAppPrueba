//
//  Enums.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 1/5/25.
//

import Foundation

enum PokemonError: LocalizedError {
    case downloadFailed(message: String)
    case coreDataError(message: String)
    case getCoreDataError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .downloadFailed(message: let message):
            return "Error al obtener el listado de pokemons: \(message), Intentalo mas tarde."
        case .coreDataError(message: let message):
            return "Error al guardar el pokemon: \(message), Intentalo mas tarde."
        case .getCoreDataError(message: let message):
            return "Error al obtener los pokemons guardados: \(message)"
        }
    }
}

enum FilterType  {
    case name
    case type
    case id
}

extension PokemonError: Identifiable {
    var id: String {
        return UUID().uuidString
    }
}
