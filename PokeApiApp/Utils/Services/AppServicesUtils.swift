//
//  AppServicesUtils.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import Foundation

struct AppServicesUtils {
    static func printRequest(requestUrl: String, method: String, parameters: [String: Any]?, customHeaders: [String: String], responseData: Data?) {
            var requestInfo = ""
            let customEncoding = method == "POST" || method == "PUT" ? "default" : "queryString"
            
            requestInfo += "--------- REQUEST ---------"
            requestInfo += "\nUrl: \(requestUrl)"
            requestInfo += "\nMethod: \(method)"
            requestInfo += "\nParameters: \(parameters?.description ?? "")"
            requestInfo += "\nEncoding: \(customEncoding)"
            requestInfo += "\nAdditional headers: \(customHeaders.description)"
            requestInfo += "\nResponse: \(responseData?.prettyPrintedJSONString ?? "")"
            requestInfo += "\n--------------------------"
            
            print(requestInfo)
    }
}

extension AppServicesUtils {
    
    struct PokemonURLs {
        static func getPokemonList(limit: Int, offset: Int) -> String {
            let endpoint = String(format: AppServicesK.PokemonEP.GET_POKEMON_LIST, String(limit), String(offset))
            return "\(AppServicesK.baseUrl)\(endpoint)"

        }
        
        static func getPokemonDetail(pokemonId: String) -> String {
            let endpoint = String(format: AppServicesK.PokemonEP.GET_POKEMON_INFO, pokemonId)
            return "\(AppServicesK.baseUrl)\(endpoint)"
        }
    }
    
}
