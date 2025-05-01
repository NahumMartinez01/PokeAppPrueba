//
//  PokeApiAppApp.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import SwiftUI

@main
struct PokeApiAppApp: App {
    @StateObject var myAppManager = MyAppManager.shared
    @StateObject private var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myAppManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
