//
//  DescriptionPokemonView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct DescriptionPokemonView: View {
    let name: String
    let type: [PokemonTypeSlot]
    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundStyle(Color.black.opacity(0.8))
                .textCase(.uppercase)
                .accessibilityLabel("Nombre del pokemon es: \(name)")
            
            HStack {
                ForEach(type) { type in
                    VStack {
                        Text(type.type.name)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundStyle(Color.black.opacity(0.8))
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.vertical, 2)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(Color.white.opacity(0.3))
                           
                    )
                    .accessibilityLabel("Pokemon \(name), el tipo del Pokemon es: \(type.type.name)")
                }
            }
           
            
        }
    }
}

#Preview {
    DescriptionPokemonView(name: "", type: [])
}
