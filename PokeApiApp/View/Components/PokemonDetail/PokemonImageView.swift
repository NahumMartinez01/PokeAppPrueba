//
//  PokemonImageView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct PokemonImageView: View {
    @EnvironmentObject var myAppManager: MyAppManager
    let urlImage: String
    var body: some View {
        AsyncImage(url: URL(string: "\(urlImage)")) { phase in
            switch phase {
            case .empty:
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .scaleEffect(1.2)
                            .opacity(0.6)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: 1)
                    )
            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .onAppear {
                        self.myAppManager.isLoadingViewVisible = false
                    }
            case .failure:
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .onAppear {
                        self.myAppManager.isLoadingViewVisible = false
                    }
            @unknown default:
                EmptyView()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 50.0)
                .fill(Color.white.opacity(0.2))
                
        )
    }
}

#Preview {
    PokemonImageView(urlImage: "")
        .environmentObject(MyAppManager())
}
