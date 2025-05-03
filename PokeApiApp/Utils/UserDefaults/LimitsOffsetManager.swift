//
//  LimitsOffsetManager.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation

final class LimitsOffsetManager {
    static let key = "lastPokemonOffset"
    
    static func getCurrentOffset() -> Int {
        UserDefaults.standard.integer(forKey: key)
    }
    
    static func imcrementOffset(_ offset: Int) {
        let current = getCurrentOffset()
        UserDefaults.standard.set(current  + offset, forKey: key)
    }
    
    static func resetOffset() {
        UserDefaults.standard.set(0, forKey: key)
    }
}

final class InitialFetchFlagManager {
    private static let key = "didPerformInitialFetch"
    
    static func wasInitialFetchDone() -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    static func markInitialFetchDone() {
        UserDefaults.standard.set(true, forKey: key)
    }

    static func reset() {
        UserDefaults.standard.set(false, forKey: key)
    }
}
