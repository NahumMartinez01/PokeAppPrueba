//
//  AppServicesK.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import Foundation

struct AppServicesK {
    static let baseUrl = "https://pokeapi.co/api/v2/"
}

extension AppServicesK {
    
    struct PokemonEP {
        static let GET_POKEMON_LIST = "pokemon?limit=%@&offset=%@"
        static let GET_POKEMON_INFO = "pokemon/%@"
    }
}

extension AppServicesK {
    public enum methodRequest: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
}
