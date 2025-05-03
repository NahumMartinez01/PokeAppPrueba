//
//  PokemonListView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct PokemonListView: View {
    @Binding var currentSearch: String
    let pokemons: [PokemonDetailModel]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(pokemons, id: \.id) { pokemon in
                        PokemonItemView(pokemon: pokemon)
                            .padding(8)
                    }
                }
                .accessibilityLabel("Listado de pokemons")
            }
            .overlay(
                Group {
                    if pokemons.isEmpty {
                        if !currentSearch.isEmpty {
                            Text("No se han encontrado resultados")
                                .foregroundColor(Color(.textError))
                                .font(.title2)
                        }
                        else {
                            Text("Tu Pokédex aún está vacía")
                                .foregroundColor(Color(.textError))
                                .font(.title2)
                        }
                    }
                    else {
                        EmptyView()
                       
                    }
                }
            )
        }
    }
}

#Preview {
    PokemonListView(currentSearch: .constant(""), pokemons: [])
}
