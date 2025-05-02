//
//  PokemonMainView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import SwiftUI
import CoreData

struct PokemonMainView: View {
    @EnvironmentObject var myAppManager: MyAppManager
    @StateObject var viewModel: PokemonMainViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: PokemonMainViewModel(viewContext: context))
    }
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea(.all)
            
            VStack {
                SearchingView(searchText: $viewModel.searchText, filterType: $viewModel.filterType){ newSearch in
                    viewModel.fetchSavedPokemons(searchText: newSearch, filterType: viewModel.filterType)
                }
                PokemonListView(pokemons: myAppManager.detailPokemon)
            }
        }
        .navigationTitle("POKEDEX")
        .task {
            viewModel.fetchSavedPokemons()
            await viewModel.getPokemonsList()
        }
        .alert(item: $viewModel.currentError) { error in
            Alert(
                title: Text("Ocurrió un error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    viewModel.currentError = nil
                }
            )
        }
    }
}

#Preview {
    PokemonMainView(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        .environmentObject(MyAppManager())
}
