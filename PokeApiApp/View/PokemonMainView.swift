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
                PokemonListView(currentSearch: $viewModel.searchText, pokemons: myAppManager.detailPokemon)
            }
        }
        .navigationTitle("POKEDEX")
        .task {
            await viewModel.loadInitialData()
        }
        .onAppear {
            myAppManager.isLoadingViewVisible = false
        }
    }
}

#Preview {
    PokemonMainView(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        .environmentObject(MyAppManager())
}
