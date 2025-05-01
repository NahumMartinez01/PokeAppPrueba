//
//  PokemonItemView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct PokemonItemView: View {
    @EnvironmentObject var myAppManager: MyAppManager
    let pokemon:PokemonDetailModel
    
    var body: some View {
        VStack {
            PokemonImageView(urlImage: pokemon.sprites.front_default ?? "")
            DescriptionPokemonView(name: pokemon.name, type: pokemon.types)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppUtils.backgroundColor(for: pokemon.types.first?.type.name ?? ""))
        )
        .shadow(color: AppUtils.backgroundColor(for: pokemon.types.first?.type.name ?? "").opacity(0.1), radius: 4, x: 0, y: 4)
        .rotation3DEffect(
            .degrees(0),
            axis: (x: 0, y: 0, z: 20),
            perspective: 0.6
        )
        .onAppear {
            print(pokemon)
        }
    }
}

#Preview {
    PokemonItemView(pokemon: PokemonDetailModel(id: 0, name: "", sprites: SpriteImages(front_default: ""), types: [] ))
}
