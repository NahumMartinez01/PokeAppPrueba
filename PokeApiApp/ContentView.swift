//
//  ContentView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var myAppManager: MyAppManager
    var body: some View {
        ZStack {
            NavigationStack {
                PokemonMainView(context: viewContext)
            }
            if myAppManager.isLoadingViewVisible {
                ZStack {
                    LoadingView(bounce: $myAppManager.bounce)
                }
                .onAppear {
                    myAppManager.bounce = true
                }
            }
        }

    }
}



#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(MyAppManager.shared)
}
