//
//  SearchingView.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 1/5/25.
//

import SwiftUI

struct SearchingView: View {
    @Binding var searchText: String
    @Binding var filterType: FilterType
    @FocusState private var isFocused: Bool
    var onSearchChange: ((String) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                TextField("Buscar", text: $searchText)
                    .frame(height: 45)
                    .padding(6)
                    .foregroundColor(.primary)
                    .focused($isFocused)
                    .background(
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(Color(.input))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color(.borderInput), lineWidth: 1)
                            )
                    )
                    .onChange(of: searchText) { newValue in
                        switch filterType {
                        case .id:
                            searchText = newValue.filter { $0.isNumber }
                        case .type:
                            searchText = newValue.filter { $0.isLetter || $0.isWhitespace }
                        default:
                            break
                        }
                        onSearchChange?(newValue)
                        
                    }
                    .accessibilityLabel("Campo de búsqueda de pokemon")
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Filtrar por:")
                    .font(.system(size: 12, weight: .semibold))
                
                Picker("Filtro", selection: $filterType) {
                    Text("Por Nombre").tag(FilterType.name)
                    Text("Por N°ID").tag(FilterType.id)
                    Text("Por Tipo").tag(FilterType.type)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.picker))
                .cornerRadius(8)
                .onChange(of: filterType) { _ in
                    searchText = ""
                    isFocused = false
                }
                .accessibilityElement(children:.combine)
                .accessibilityLabel("Selector de tipo de filtro para Pokémon")
                .accessibilityHint("Elige cómo filtrar los Pokémon: por nombre, número de identificación o tipo")
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color(.backgroundHeader))
        .padding(.bottom)
    }
}

#Preview {
    SearchingView(searchText: .constant(""), filterType: .constant(.name))
}
