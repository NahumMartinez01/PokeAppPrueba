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
                .foregroundStyle(Color.white)
            HStack {
                ForEach(type) { type in
                    VStack {
                        Text(type.type.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.vertical, 2)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(Color.white.opacity(0.3))
                           
                    }
                }
            }
            
        }
    }
}

#Preview {
    DescriptionPokemonView(name: "", type: [])
}
