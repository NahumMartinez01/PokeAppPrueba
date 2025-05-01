//
//  PokemonMainView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import SwiftUI
import CoreData

struct PokemonMainView: View {
    @StateObject var viewModel: PokemonMainViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: PokemonMainViewModel(viewContext: context))
    }
    
    var body: some View {
        
        VStack {
                PokemonListView(pokemons: viewModel.detailPokemon)
        }
        .task {
            await viewModel.getPokemonsList()
        }
        
    }
}


#Preview {
    PokemonMainView(context: NSManagedObjectContext()  )
}
