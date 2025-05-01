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
            Text("POKEDEX")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
                .font(.system(size: 32, weight: .bold))
                
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(pokemons) { pokemon in
                        PokemonItemView(pokemon: pokemon)
                            .padding(8)
                    }
                }
            }
        }
    }
}


#Preview {
    PokemonListView(pokemons: [])
}
