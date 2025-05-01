//
//  MyAppManager.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import Foundation

// NOTE: This is the source of truth for the App
class MyAppManager: ObservableObject {
    @Published var isLoadingViewVisible: Bool = false
    
    static let shared = MyAppManager()
    
    init(
        isLoadingViewVisible: Bool = false
    ) {
        self.isLoadingViewVisible = isLoadingViewVisible
    }
}
