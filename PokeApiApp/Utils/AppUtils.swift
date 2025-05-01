//
//  AppUtils.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//


import Foundation
import SwiftUI

class AppUtils {
    
    static func backgroundColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return Color(red: 255/255, green: 99/255, blue: 71/255)
        case "water": return Color(red: 100/255, green: 180/255, blue: 255/255)
        case "grass": return Color(red: 120/255, green: 200/255, blue: 80/255)
        case "electric": return Color(red: 255/255, green: 234/255, blue: 105/255)
        case "psychic": return Color(red: 255/255, green: 133/255, blue: 173/255)
        case "ice": return Color(red: 180/255, green: 255/255, blue: 255/255)
        case "dragon": return Color(red: 160/255, green: 120/255, blue: 255/255)
        case "dark": return Color(red: 80/255, green: 80/255, blue: 80/255)
        case "fairy": return Color(red: 255/255, green: 182/255, blue: 255/255)
        case "fighting": return Color(red: 255/255, green: 115/255, blue: 115/255)
        case "normal": return Color(red: 220/255, green: 220/255, blue: 220/255)
        case "poison": return Color(red: 160/255, green: 64/255, blue: 160/255) // Add poison
        case "flying": return Color(red: 168/255, green: 184/255, blue: 240/255)
        default: return Color.gray.opacity(0.3)
        }
    }
    
//    (id: 3, name: "venusaur", sprites: PokeApiApp.SpriteImages(front_default: Optional("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png")), types: [PokeApiApp.PokemonTypeSlot(slot: 2, type: PokeApiApp.PokemonType(name: "poison")), PokeApiApp.PokemonTypeSlot(slot: 1, type: PokeApiApp.PokemonType(name: "grass"))])

}
