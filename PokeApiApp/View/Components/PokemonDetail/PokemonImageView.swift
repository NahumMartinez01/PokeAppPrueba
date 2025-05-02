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
                ImageLoadingView()
                    .frame(width: 100, height: 100)
            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
            case .failure:
                EmptyView()
                    .onAppear {
                        myAppManager.errorMessage = .downloadFailed(message: "No se pudo descargar la imagen del Pokémon")
                        myAppManager.showErrorAlert = true
                    }
            @unknown default:
                EmptyView()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 50.0)
                .fill(Color.gray.opacity(0.2))
                
        )
        .alert(isPresented: $myAppManager.showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(myAppManager.errorMessage?.errorDescription  ?? "Error desconocido"),
                        dismissButton: .default(Text("OK")) {
                            myAppManager.errorMessage = nil 
                        }
                    )
                }
    }
}

#Preview {
    PokemonImageView(urlImage: "")
        .environmentObject(MyAppManager())
}
