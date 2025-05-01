//
//  LoadingView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import SwiftUI

struct LoadingView: View {
    @Binding var bounce: Bool
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 235/255, green: 0/255, blue: 27/255),
                    Color(red: 150/255, green: 0, blue: 0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: UIScreen.main.bounds.height * 0.50)
            
            Color.black
                .frame(height: 2)
            
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.9),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: UIScreen.main.bounds.height * 0.50)
        }
        .edgesIgnoringSafeArea(.all)
        VStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.40)
            
            Image(.pokebolaLoading)
                .resizable()
                .frame(width: 150, height: 150)
                .offset(y: bounce ? -20 : 0)
                .animation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                    value: bounce
                )
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoadingView(bounce: .constant(false))
}
