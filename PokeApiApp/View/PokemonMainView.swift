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
    @State private var savedPokemons: [PokemonDetailEntity] = []
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: PokemonMainViewModel(viewContext: context))
    }
    
    var body: some View {
        
        VStack {
            if viewModel.detailPokemon.isEmpty {
                Text("Vacio")
            }else {
                PokemonListView(pokemons: viewModel.detailPokemon)
            }
        }
        .task {
                if viewModel.detailPokemon.isEmpty {
                    await viewModel.getPokemonsList()
                }
        }
        
    }
}


#Preview {
    PokemonMainView(context: NSManagedObjectContext()  )
}
