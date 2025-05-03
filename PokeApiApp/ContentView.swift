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
                   // myAppManager.showLoading()
                }
            }
        }
        .alert(isPresented: $myAppManager.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(myAppManager.errorMessage?.localizedDescription ?? "Ha ocurrido un error"),
                dismissButton: .default(Text("OK")) {
                    myAppManager.errorMessage = nil
                }
            )
        }
    }
}



#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(MyAppManager.shared)
}
