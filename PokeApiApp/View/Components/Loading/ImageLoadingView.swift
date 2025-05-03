//
//  ImageLoadingView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 1/5/25.
//

import SwiftUI

struct ImageLoadingView: View {
    @State private var isRotating = false

    var body: some View {
        Image(.pokebolaLoading)
            .resizable()
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(
                .linear(duration: 0.5)
                    .repeatForever(autoreverses: false),
                value: isRotating
            )
            .onAppear {
                isRotating = true
            }
    }
}

#Preview {
    ImageLoadingView()
}
