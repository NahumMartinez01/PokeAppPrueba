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
    @State private var bounce: Bool = false
    var body: some View {
        ZStack {
            
            Color(.background)
                .ignoresSafeArea(.all)
            
            PokemonMainView(context: viewContext)
            
            if myAppManager.isLoadingViewVisible {
                ZStack {
                    LoadingView(bounce: $bounce)
                }
                .onAppear {
                    bounce = true
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
