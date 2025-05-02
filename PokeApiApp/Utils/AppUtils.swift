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
        case "poison": return Color(red: 160/255, green: 64/255, blue: 160/255)
        case "flying": return Color(red: 168/255, green: 184/255, blue: 240/255)
        case "bug": return Color(red: 168/255, green: 184/255, blue: 32/255)
        case "ground": return Color(red: 222/255, green: 193/255, blue: 107/255)
        case "rock": return Color(red: 184/255, green: 160/255, blue: 56/255)
        case "ghost": return Color(red: 112/255, green: 88/255, blue: 152/255)
        case "steel": return Color(red: 184/255, green: 184/255, blue: 208/255)
        default: return Color.gray.opacity(0.3)
        }
    }

    
    static func backgroundGradient(for type: String) -> LinearGradient {
        let base: Color
        let highlight: Color
        
        switch type.lowercased() {
        case "fire":
            base = Color(red: 255/255, green: 99/255, blue: 71/255)
            highlight = Color(red: 255/255, green: 150/255, blue: 100/255)
        case "water":
            base = Color(red: 100/255, green: 180/255, blue: 255/255)
            highlight = Color(red: 150/255, green: 210/255, blue: 255/255)
        case "grass":
            base = Color(red: 120/255, green: 200/255, blue: 80/255)
            highlight = Color(red: 150/255, green: 255/255, blue: 120/255)
        case "electric":
            base = Color(red: 255/255, green: 234/255, blue: 105/255)
            highlight = Color(red: 255/255, green: 255/255, blue: 150/255)
        case "psychic":
            base = Color(red: 255/255, green: 133/255, blue: 173/255)
            highlight = Color(red: 255/255, green: 180/255, blue: 230/255)
        case "ice":
            base = Color(red: 180/255, green: 255/255, blue: 255/255)
            highlight = Color(red: 200/255, green: 255/255, blue: 255/255)
        case "dragon":
            base = Color(red: 160/255, green: 120/255, blue: 255/255)
            highlight = Color(red: 190/255, green: 150/255, blue: 255/255)
        case "dark":
            base = Color(red: 80/255, green: 80/255, blue: 80/255)
            highlight = Color(red: 100/255, green: 100/255, blue: 100/255)
        case "fairy":
            base = Color(red: 255/255, green: 182/255, blue: 255/255)
            highlight = Color(red: 255/255, green: 220/255, blue: 255/255)
        case "fighting":
            base = Color(red: 255/255, green: 115/255, blue: 115/255)
            highlight = Color(red: 255/255, green: 160/255, blue: 160/255)
        case "normal":
            base = Color(red: 220/255, green: 220/255, blue: 220/255)
            highlight = Color(red: 240/255, green: 240/255, blue: 240/255)
        case "poison":
            base = Color(red: 160/255, green: 64/255, blue: 160/255)
            highlight = Color(red: 200/255, green: 100/255, blue: 200/255)
        case "flying":
            base = Color(red: 168/255, green: 184/255, blue: 240/255)
            highlight = Color(red: 180/255, green: 200/255, blue: 255/255)
        case "bug":
            base = Color(red: 168/255, green: 184/255, blue: 32/255)
            highlight = Color(red: 200/255, green: 220/255, blue: 60/255)
        case "ground":
            base = Color(red: 222/255, green: 193/255, blue: 107/255)
            highlight = Color(red: 240/255, green: 215/255, blue: 140/255)
        case "rock":
            base = Color(red: 184/255, green: 160/255, blue: 56/255)
            highlight = Color(red: 220/255, green: 190/255, blue: 90/255)
        case "ghost":
            base = Color(red: 112/255, green: 88/255, blue: 152/255)
            highlight = Color(red: 140/255, green: 120/255, blue: 180/255)
        case "steel":
            base = Color(red: 184/255, green: 184/255, blue: 208/255)
            highlight = Color(red: 210/255, green: 210/255, blue: 230/255)
        default:
            base = Color.gray.opacity(0.3)
            highlight = Color.gray.opacity(0.1)
        }
        
        return LinearGradient(
            gradient: Gradient(colors: [base, highlight]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func extractID(from url: String) -> Int? {
            let trimmed = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            let components = trimmed.components(separatedBy: "/")
            return Int(components.last ?? "")
        }
}
