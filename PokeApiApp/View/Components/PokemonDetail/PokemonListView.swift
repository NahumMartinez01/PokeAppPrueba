//
//  PokemonListView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct PokemonListView: View {
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
                pokemons.isEmpty ? Text("No se encontraron Pokémons")
                    .foregroundColor(.gray)
                    .font(.subheadline) : nil
            )
        }
    }
}
    #Preview {
        PokemonListView(pokemons: [])
    }
